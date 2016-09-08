require 'erb'

module Watizzle
  module Locators
    class Element
      class Locator < Watir::Locators::Element::Locator
        SIZZLE_LOADER_PATH = File.expand_path('../../../sizzle/loader.js.erb', __FILE__)

        def locate
          e = by_id and return e # short-circuit if :id is given
          element = find_first_by_multiple
          element_validator.validate(element, @selector) if element
        rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::StaleElementReferenceError
          nil
        end

        def locate_all
          find_all_by_multiple
        end

        private

        def by_id
          return unless id = @selector[:id] and id.is_a? String

          selector = @selector.dup
          selector.delete(:id)

          tag_name = selector.delete(:tag_name)
          return unless selector.empty? # multiple attributes

          element = retrieve_element(sizzle_locator("##{id}"))
          return if element && tag_name && !element_validator.validate(element, selector)

          element
        end

        def find_first_by_multiple
          selector = selector_builder.normalized_selector
          how, what = selector_builder.build(selector)

          if how == :sizzle
            retrieve_element(sizzle_locator(what))
          else
            super
          end
        end

        def find_all_by_multiple
          selector = selector_builder.normalized_selector

          if selector.key? :index
            raise ArgumentError, "can't locate all elements by :index"
          end

          how, what = selector_builder.build(selector)

          if how == :sizzle
            retrieve_elements(sizzle_locator(what))
          else
            super
          end
        end

        def retrieve_element(locator)
          retrieve_elements("#{locator}[0]")
        end

        def retrieve_elements(locator)
          args = [locator]
          args << @query_scope.wd if locate_inside_parent?

          execute_script(*args)
        end

        def execute_script(locator, parent = nil)
          browser = case @query_scope
                    when Watir::IFrame
                      # TODO: we should not do that
                      @query_scope.tap(&:switch_to!)
                    when Watir::Element
                      @query_scope.browser
                    else
                      @query_scope
                    end

          load_and_locate_script = ERB.new(File.read(SIZZLE_LOADER_PATH)).result(binding)

          args = [load_and_locate_script]
          args << parent if parent

          browser.driver.execute_script(*args)
        end

        def sizzle_locator(selector)
          loc = "return Sizzle('#{selector}'"
          loc << ', arguments[0]' if locate_inside_parent?
          loc << ')'
        end

        def locate_inside_parent?
          @query_scope.is_a?(Watir::Element) && !@query_scope.is_a?(Watir::IFrame)
        end
      end
    end
  end
end

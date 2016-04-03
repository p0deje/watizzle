require 'erb'

module Watizzle
  module Locators
    class Element
      class Locator < Watir::Locators::Element::Locator
        SIZZLE_LOADER_PATH = File.expand_path('../../../sizzle/loader.js.erb', __FILE__)

        def initialize(*)
          super
          inject_sizzle
        end

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

        def inject_sizzle
          loader = ERB.new(File.read(SIZZLE_LOADER_PATH))
          execute_script(loader.result)
        end

        def retrieve_element(locator)
          retrieve_elements("#{locator}[0]")
        end

        def retrieve_elements(locator)
          args = [locator]
          args << @parent.wd if locate_inside_parent?
          execute_script(*args)
        end

        def execute_script(*args)
          browser = case @parent
                    when Watir::IFrame
                      # TODO: we should not do that
                      @parent.tap(&:switch_to!)
                    when Watir::Element
                      @parent.browser
                    else
                      @parent
                    end
          browser.driver.execute_script(*args)
        end

        def sizzle_locator(selector)
          loc = "return Sizzle('#{selector}'"
          loc << ', arguments[0]' if locate_inside_parent?
          loc << ')'
        end

        def locate_inside_parent?
          @parent.is_a?(Watir::Element) && !@parent.is_a?(Watir::IFrame)
        end
      end
    end
  end
end

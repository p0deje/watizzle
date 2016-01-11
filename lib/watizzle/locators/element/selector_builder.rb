module Watizzle
  class Element
    class SelectorBuilder < Watir::Element::SelectorBuilder
      def build(selector)
        given_xpath_or_css(selector.dup) || build_sizzle_selector(selector)
      end

      private

      def given_xpath_or_css(selector)
        # index should not be present for given_xpath_or_css
        selector.delete(:index)
        super
      end

      def build_sizzle_selector(selectors)
        sizzle_builder.build(selectors)
      end

      def sizzle_builder
        @sizzle_builder ||= Sizzle.new
      end
    end
  end
end

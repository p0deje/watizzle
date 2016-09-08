module Watizzle
  module Locators
    class Element
      class SelectorBuilder
        class Sizzle
          def build(selectors)
            if selectors.empty?
              sizzle = '*'
            else
              sizzle = ''
              sizzle << (selectors.delete(:tag_name) || '')
            end

            klass = selectors.delete(:class)
            if klass
              if klass.is_a?(String)
                if klass.include? ' '
                  sizzle << %([class="#{escape_quotes(klass)}"])
                else
                  sizzle << ".#{klass}"
                end
              else
                sizzle << %(:regexp(class, #{klass.inspect}))
              end
            end

            href = selectors.delete(:href)
            if href
              if href.is_a?(String)
                sizzle << %([href~="#{escape_quotes(href)}"])
              else
                sizzle << %(:regexp(href, #{href.inspect}))
              end
            end

            text = selectors.delete(:text)
            if text
              if text.is_a?(String)
                sizzle << %(:contains("#{escape_quotes(text)}"))
              else
                sizzle << %(:regexp(text, #{text.inspect}))
              end
            end

            if selectors.key?(:visible)
              sizzle << (selectors.delete(:visible) ? ':visible' : ':hidden')
            end

            index = selectors.delete(:index)

            selectors.each do |key, value|
              key = key.to_s.tr("_", "-")

              case value
              when String, Fixnum
                sizzle << %([#{key}="#{escape_quotes(value)}"])
              when Regexp
                sizzle << %(:regexp(#{key}, #{value.inspect}))
              end
            end

            if index
              sizzle << %(:eq(#{index}))
            end

            p sizzle: sizzle, selectors: selectors if $DEBUG

            [:sizzle, sizzle]
          end

          private

          def escape_quotes(str)
            # OMG, what's going on here?
            str.to_s.gsub('"', '\\\\\\\\\"')
          end
        end
      end
    end
  end
end

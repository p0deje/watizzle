describe Watizzle::Locators::Element::Locator do
  include LocatorSpecHelper

  describe "finds a single element" do
    describe 'with class' do
      it 'finds by class name' do
        expect_one '.foo'
        locate_one class: 'foo'
      end

      it 'finds by class name with spaces' do
        expect_one '[class="foo bar"]'
        locate_one class: 'foo bar'
      end
    end

    describe 'with id' do
      it 'finds by identifier' do
        expect_one '#foo'
        locate_one id: 'foo'
      end

      xit 'finds by identifier with spaces' do
        expect_one '[id="foo bar"]'
        locate_one id: 'foo bar'
      end
    end

    describe 'with tag name' do
      it 'finds by tag name' do
        expect_one 'foo'
        locate_one tag_name: 'foo'
      end
    end

    describe "with selectors not supported by webdriver" do
      it "handles selector with tag name and a single attribute" do
        expect_one 'div[title="foo"]'
        locate_one tag_name: "div", title: "foo"
      end

      it "handles selector with no tag name and and a single attribute" do
        expect_one '[title="foo"]'
        locate_one title: "foo"
      end

      it "handles single quotes in the attribute string" do
        expect_one %{[title="foo and 'bar'"]}
        locate_one title: "foo and 'bar'"
      end

      it "handles selector with tag name and multiple attributes" do
        expect_one 'div[title="foo"][dir="bar"]'
        locate_one [:tag_name, "div",
                    :title   , "foo",
                    :dir     , 'bar']
      end

      it "handles selector with no tag name and multiple attributes" do
        expect_one '[dir="foo"][title="bar"]'
        locate_one [:dir,   "foo",
                    :title, "bar"]
      end
    end

    describe "with special cased selectors" do
      it "normalizes space for :text" do
        expect_one 'div:contains("foo")'
        locate_one tag_name: "div", text: "foo"
      end

      it "translates :caption to :text" do
        expect_one 'div:contains("foo")'
        locate_one tag_name: "div", caption: "foo"
      end

      it "translates :class_name to :class" do
        expect_one "div.foo"
        locate_one tag_name: "div", class_name: "foo"
      end

      it "handles data-* attributes" do
        expect_one 'div[data-name="foo"]'
        locate_one tag_name: "div", data_name: "foo"
      end

      it "handles aria-* attributes" do
        expect_one 'div[aria-label="foo"]'
        locate_one tag_name: "div", aria_label: "foo"
      end

      it "normalizes space for the :href attribute" do
        expect_one 'a[href~="foo"]'

        selector = {
          tag_name: "a",
          href: "foo"
        }
        locate_one selector, Watir::Anchor.attributes
      end

      xit "wraps :type attribute with translate() for upper case values" do
        translated_type = "translate(@type,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"
        expect_one :xpath, ".//input[#{translated_type}='file']"

        selector = [
          :tag_name, "input",
          :type    , "file",
        ]

        locate_one selector, Watir::Input.attributes
      end

      xit "uses the corresponding <label>'s @for attribute or parent::label when locating by label" do
        translated_type = "translate(@type,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"
        expect_one :xpath, ".//input[#{translated_type}='text' and (@id=//label[normalize-space()='foo']/@for or parent::label[normalize-space()='foo'])]"

        selector = [
          :tag_name, "input",
          :type    , "text",
          :label   , "foo"
        ]

        locate_one selector, Watir::Input.attributes
      end

      it "uses label attribute if it is valid for element" do
        expect_one 'option[label="foo"]'

        selector = { tag_name: "option", label: "foo" }
        locate_one selector, Watir::Option.attributes
      end

      it "translates ruby attribute names to content attribute names" do
        expect_one 'meta[http-equiv="foo"]'

        selector = {
          tag_name: "meta",
          http_equiv: "foo"
        }
        locate_one selector, Watir::Meta.attributes
      end
    end

    describe "with regexp selectors" do
      it "handles selector with tag name and a single regexp attribute" do
        expect_one 'div:regexp(class, /oob/)'
        locate_one(tag_name: "div", class: /oob/)
      end

      it "handles :tag_name, :index and a single regexp attribute" do
        expect_one 'div:regexp(class, /foo/):eq(1)'

        selector = {
          tag_name: "div",
          class: /foo/,
          index: 1
        }
        locate_one(selector)
      end

      it "handles mix of string and regexp attributes" do
        expect_one 'div[dir="foo"]:regexp(title, /baz/)'

        selector = {
          tag_name: "div",
          dir: "foo",
          title: /baz/
        }
        locate_one(selector)
      end

      it "handles data-* attributes with regexp" do
        expect_one 'div:regexp(data-automation-id, /bar/)'

        selector = {
          tag_name: "div",
          data_automation_id: /bar/
        }

        locate_one(selector)
      end

      xit "handles :label => /regexp/ selector" do
        label_elements = [
          element(tag_name: "label", text: "foo", attributes: { for: "bar"}),
          element(tag_name: "label", text: "foob", attributes: { for: "baz"})
        ]
        div_elements = [element(tag_name: "div")]

        expect_all(:tag_name, "label").ordered.and_return(label_elements)

        if Watir.prefer_css?
          expect_all(:css, 'div[id="baz"]').ordered.and_return(div_elements)
        else
          expect_all(:xpath, ".//div[@id='baz']").ordered.and_return(div_elements)
        end

        expect(locate_one(tag_name: "div", label: /oob/)).to eq div_elements.first
      end

      xit "returns nil when no label matching the regexp is found" do
        expect_all(:tag_name, "label").and_return([])
        expect(locate_one(tag_name: "div", label: /foo/)).to be_nil
      end
    end

    it "finds all if :index is given" do
      expect_one 'div[dir="foo"]:eq(1)'

      selector = {
        tag_name: "div",
        dir: "foo",
        index: 1
      }
      locate_one(selector)
    end

    describe "errors" do
      it "raises a TypeError if :index is not a Fixnum" do
        expect { locate_one(tag_name: "div", index: "bar") }.to \
          raise_error(TypeError, %[expected Fixnum, got "bar":String])
      end

      it "raises a TypeError if selector value is not a String or Regexp" do
        expect { locate_one(tag_name: 123) }.to \
          raise_error(TypeError, %[expected one of [String, Regexp], got 123:Fixnum])
      end

      it "raises a MissingWayOfFindingObjectException if the attribute is not valid" do
        bad_selector = {tag_name: "input", href: "foo"}
        valid_attributes = Watir::Input.attributes

        expect { locate_one(bad_selector, valid_attributes) }.to \
          raise_error(Watir::Exception::MissingWayOfFindingObjectException, "invalid attribute: :href")
      end
    end
  end

  describe "finds several elements" do
    describe 'with class' do
      it 'finds by class name' do
        expect_all '.foo'
        locate_all class: 'foo'
      end

      it 'finds by class name with spaces' do
        expect_all '[class="foo bar"]'
        locate_all class: 'foo bar'
      end
    end

    describe 'with tag name' do
      it 'finds by tag name' do
        expect_all 'foo'
        locate_all tag_name: 'foo'
      end
    end

    describe "with an empty selector" do
      it "finds all when an empty selctor is given" do
        expect_all '*'
        locate_all({})
      end
    end

    describe "with selectors not supported by webdriver" do
      it "handles selector with tag name and a single attribute" do
        expect_all 'div[dir="foo"]'
        locate_all tag_name: "div", dir: "foo"
      end

      it "handles selector with tag name and multiple attributes" do
        expect_all 'div[dir="foo"][title="bar"]'
        locate_all [:tag_name, "div",
                    :dir     , "foo",
                    :title   , 'bar']
      end
    end

    describe "with regexp selectors" do
      it "handles selector with tag name and a single regexp attribute" do
        expect_all 'div:regexp(class, /oob/)'
        locate_all(tag_name: "div", class: /oob/)
      end

      it "handles mix of string and regexp attributes" do
        expect_all 'div[dir="foo"]:regexp(title, /baz/)'

        selector = {
          tag_name: "div",
          dir: "foo",
          title: /baz/
        }
        locate_all(selector)
      end

      describe "errors" do
        it "raises ArgumentError if :index is given" do
          expect { locate_all(tag_name: "div", index: 1) }.to \
            raise_error(ArgumentError, "can't locate all elements by :index")
        end
      end
    end
  end
end

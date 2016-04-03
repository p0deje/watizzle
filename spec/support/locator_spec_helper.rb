require 'active_support'

module LocatorSpecHelper
  def browser
    @browser ||= double(Watir::Browser, driver: driver)
  end

  def driver
    @driver ||= double(Selenium::WebDriver::Driver)
    allow(@driver).to receive(:execute_script)

    @driver
  end

  def locator(selector, attrs)
    attrs ||= Watir::HTMLElement.attributes
    element_validator = Watizzle::Locators::Element::Validator.new
    selector_builder = Watizzle::Locators::Element::SelectorBuilder.new(driver, selector, attrs)
    Watizzle::Locators::Element::Locator.new(browser, selector, selector_builder, element_validator)
  end

  def expect_one(selector)
    expect(driver).to receive(:execute_script).with(%{return Sizzle('#{selector}')[0]}).and_return(element)
  end

  def expect_all(selector)
    expect(driver).to receive(:execute_script).with(%{return Sizzle('#{selector}')}).and_return(elements)
  end

  def locate_one(selector, attrs = nil)
    locator(ordered_hash(selector), attrs).locate
  end

  def locate_all(selector, attrs = nil)
    locator(ordered_hash(selector), attrs).locate_all
  end

  def element
    double(Watir::Element).as_null_object
  end

  def elements
    double(Watir::ElementCollection).as_null_object
  end

  def ordered_hash(selector)
    case selector
    when Hash
      selector
    when Array
      ActiveSupport::OrderedHash[*selector]
    else
      raise ArgumentError, "couldn't create hash for #{selector.inspect}"
    end
  end
end

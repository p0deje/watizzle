require 'watir-webdriver'

require 'watizzle/locators/element/locator'
require 'watizzle/locators/element/selector_builder'
require 'watizzle/locators/element/selector_builder/sizzle'
require 'watizzle/version'

# monkey patch watir-webdriver locators
begin
  # silence constant defined warnings
  old_verbose, $VERBOSE = $VERBOSE, nil

  Watir::Element::Locator         = Watizzle::Element::Locator
  Watir::Element::SelectorBuilder = Watizzle::Element::SelectorBuilder
  Watizzle::Element::Validator    = Watir::Element::Validator
ensure
  $VERBOSE = old_verbose
end

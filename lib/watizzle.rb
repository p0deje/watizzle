require 'watir'

require 'watizzle/locators/element/locator'
require 'watizzle/locators/element/selector_builder'
require 'watizzle/locators/element/selector_builder/sizzle'
require 'watizzle/locators/element/validator'
require 'watizzle/version'

Watir.locator_namespace = Watizzle::Locators

# Some locators cannot be easily re-implemented using Watizzle,
# so we just fallback to default Watir locators

Watizzle::Locators::Button    = Watir::Locators::Button
Watizzle::Locators::Cell      = Watir::Locators::Cell
Watizzle::Locators::Row       = Watir::Locators::Row
Watizzle::Locators::TextArea  = Watir::Locators::TextArea
Watizzle::Locators::TextField = Watir::Locators::TextField

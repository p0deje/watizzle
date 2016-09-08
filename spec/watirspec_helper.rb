require 'pry'
require 'watirspec'
require 'watizzle'

WatirSpec.implementation do |watirspec|
  watirspec.name = :watizzle
  watirspec.browser_class = Watir::Browser
  watirspec.browser_args = [:phantomjs, {}]
  watirspec.guard_proc = lambda do |watirspec_guards|
    watizzle_guards = [:phantomjs]
    watizzle_guards << :relaxed_locate if Watir.relaxed_locate?
    watizzle_guards << :not_relaxed_locate unless Watir.relaxed_locate?

    watirspec_guards.any? { |guard| watizzle_guards.include?(guard) }
  end
end

WatirSpec.run!

include Watir

WatirSpec.implementation do |watirspec|
  watirspec.name = :watizzle
  watirspec.browser_class = Watir::Browser
  watirspec.browser_args = [:firefox, {}]
  watirspec.guard_proc = lambda do |args|
    args.any? do |arg|
      [
        :webdriver,
        :firefox,
        %i[webdriver firefox]
      ].include?(arg)
    end
  end
end

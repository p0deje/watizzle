include Watir

WatirSpec.implementation do |watirspec|
  watirspec.name = :watizzle
  watirspec.browser_class = Watir::Browser
  watirspec.browser_args = [:firefox, {}]
  watirspec.guard_proc = lambda do |args|
    args.include?(:firefox)
    # args.any? { |arg| arg == :firefox }
  end
end

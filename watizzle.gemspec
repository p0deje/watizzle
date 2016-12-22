lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'watizzle/version'

Gem::Specification.new do |spec|
  spec.name          = 'watizzle'
  spec.version       = Watizzle::VERSION
  spec.authors       = ['Alex Rodionov']
  spec.email         = ['p0deje@gmail.com']

  spec.summary       = 'for watir my sizzle'
  spec.description   = 'Sizzle.js locator engine for Watir'
  spec.homepage      = 'https://github.com/p0deje/watizzle'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'watir', '>= 6.0.3'

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end

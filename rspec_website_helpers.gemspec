# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_website_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec_website_helpers"
  spec.version       = RspecWebsiteHelpers::VERSION
  spec.authors       = ["Thomas Schank"]
  spec.email         = ["DrTom@schank.ch"]

  spec.summary       = %q{Helpers for testing websites with rspec.}
  spec.description   = %q{Helpers for testing websites with rspec.}
  spec.homepage      = "https://github.com/DrTom/rspec_website_helpers.git"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'activesupport', '>= 4.0.0', '< 5.0.0'
  spec.add_dependency 'addressable', '>= 2', '< 3'
  spec.add_dependency 'rspec', '>= 3.3', '< 4'
  spec.add_dependency 'faraday'

end

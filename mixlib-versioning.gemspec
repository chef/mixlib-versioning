# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mixlib/versioning/version'

Gem::Specification.new do |gem|
  gem.name          = "mixlib-versioning"
  gem.version       = Mixlib::Versioning::VERSION
  gem.authors       = ["Opscode", "Seth Chisamore"]
  gem.email         = ["info@opscode.com", "schisamo@opscode.com"]
  gem.description   = "General purpose Ruby library that allows you to parse, compare and manipulate version strings in multiple formats."
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/opscode/mixlib-versioning"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec_junit_formatter"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end

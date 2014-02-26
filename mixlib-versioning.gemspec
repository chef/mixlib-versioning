# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mixlib/versioning/version'

Gem::Specification.new do |spec|
  spec.name          = 'mixlib-versioning'
  spec.version       = Mixlib::Versioning::VERSION
  spec.authors       = ['Seth Chisamore', 'Christopher Maier']
  spec.email         = ['schisamo@opscode.com', 'cm@opscode.com']
  spec.description   = 'General purpose Ruby library that allows you to parse, compare and manipulate version strings in multiple formats.'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/opscode/mixlib-versioning'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Development dependencies
  spec.add_development_dependency 'rspec',   '~> 2.14'
end

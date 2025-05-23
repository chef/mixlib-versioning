lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mixlib/versioning/version"

Gem::Specification.new do |spec|
  spec.name          = "mixlib-versioning"
  spec.version       = Mixlib::Versioning::VERSION
  spec.authors       = ["Seth Chisamore", "Christopher Maier"]
  spec.description   = "General purpose Ruby library that allows you to parse, compare and manipulate version strings in multiple formats."
  spec.summary       = spec.description
  spec.email         = "info@chef.io"
  spec.homepage      = "https://github.com/chef/mixlib-versioning"
  spec.license       = "Apache-2.0"

  spec.files         = %w{LICENSE} + Dir.glob("lib/**/*")
  spec.require_paths = ["lib"]

  # we support EOL ruby because we use this in chef_client_updater cookbook with very old Chef / Ruby releases
  spec.required_ruby_version = ">= 2.0"
end

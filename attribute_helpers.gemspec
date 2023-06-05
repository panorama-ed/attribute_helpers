# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "attribute_helpers/version"

Gem::Specification.new do |spec|
  spec.name          = "attribute_helpers"
  spec.version       = AttributeHelpers::VERSION
  spec.authors       = ["Jacob Evelyn"]
  spec.email         = ["jevelyn@panoramaed.com"]
  spec.summary       = "Provides auto-serialization of simple Ruby types that "\
                       "databases do not support."
  spec.description   = "Provides auto-serialization of simple Ruby types that "\
                       "databases do not support, such as symbols and classes."
  spec.homepage      = "https://github.com/panorama-ed/attribute_helpers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.metadata["rubygems_mfa_required"] = "true"
end

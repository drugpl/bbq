# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bbq/rspec/version"

Gem::Specification.new do |spec|
  spec.name          = "bbq-rspec"
  spec.version       = Bbq::RSpec::VERSION
  spec.authors       = ["DRUG - Dolnośląska Grupa Użytkowników Ruby"]
  spec.email         = ["bbq@drug.org.pl"]
  spec.summary       = %q{RSpec integration for bbq.}
  spec.description   = %q{RSpec integration for bbq.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bbq-core", ">= 0.0"
  spec.add_dependency "rspec",    ">= 2.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake",    "~> 10.0"
end

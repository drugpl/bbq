# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bbq/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "bbq-rails"
  spec.version       = Bbq::Rails::VERSION
  spec.authors       = ["DRUG - Dolnośląska Grupa Użytkowników Ruby"]
  spec.email         = ["all@drug.org.pl"]
  spec.summary       = %q{Rails integration for Bbq.}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bbq-core", "= 0.3.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails",    ">= 5.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end

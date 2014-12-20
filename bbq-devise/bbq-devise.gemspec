# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bbq/devise/version'

Gem::Specification.new do |spec|
  spec.name          = "bbq-devise"
  spec.version       = Bbq::Devise::VERSION
  spec.authors       = ["Paweł Pacana"]
  spec.email         = ["pawel.pacana@gmail.com"]
  spec.summary       = %q{Devise integration for bbq.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bbq-core", ">= 0.0"

  spec.add_development_dependency "bundler",  "~> 1.7"
  spec.add_development_dependency "rake",     "~> 10.0"
  spec.add_development_dependency "devise",   ">= 1.4"
  spec.add_development_dependency "minitest", ">= 4.0"
end

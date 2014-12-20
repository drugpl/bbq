# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bbq/version"

Gem::Specification.new do |s|
  s.name        = "bbq"
  s.version     = Bbq::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["DRUG - Dolnośląska Grupa Użytkowników Ruby"]
  s.email       = ["bbq@drug.org.pl"]
  s.homepage    = ""
  s.description = %q{Objected oriented acceptance testing for Rails, using personas.}
  s.summary     = %q{Objected oriented acceptance testing for Rails, using personas.}

  s.rubyforge_project = "bbq"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "bbq-core" , ">= 0.0"
  s.add_dependency "bbq-rspec", ">= 0.0"
  s.add_dependency "bbq-rails", ">= 0.0"

  s.add_development_dependency "bundler",  "~> 1.7"
  s.add_development_dependency "rake",     "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.0"
end

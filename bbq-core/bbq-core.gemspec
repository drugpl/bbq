# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bbq/core/version"

Gem::Specification.new do |s|
  s.name        = "bbq-core"
  s.version     = Bbq::Core::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["DRUG - Dolnośląska Grupa Użytkowników Ruby"]
  s.email       = ["bbq@drug.org.pl"]
  s.homepage    = ""
  s.description = %q{Objected oriented acceptance testing for Rails, using personas.}
  s.summary     = %q{Objected oriented acceptance testing for Rails, using personas.}

  s.rubyforge_project = "bbq-core"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "capybara",      "~> 2.0"
  s.add_dependency "activesupport", ">= 2.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc",     "~> 3.7"
  s.add_development_dependency "minitest", "~> 5.0"
end

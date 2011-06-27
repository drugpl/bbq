# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bbq/version"

Gem::Specification.new do |s|
  s.name        = "bbq"
  s.version     = Bbq::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["DRUG - Dolnośląska Grupa Użytkowników Ruby"]
  s.email       = ["pawel.pacana+bbq@gmail.com"]
  s.homepage    = ""
  s.description = %q{Objected oriented acceptance testing using personas.}

  s.rubyforge_project = "bbq"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "capybara",  "~> 1.0.0"
  s.add_dependency "rails",     ">= 3.0.0"

  s.add_development_dependency "sqlite3", "~> 1.3.3"
end

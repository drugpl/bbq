# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bbq/version"

Gem::Specification.new do |s|
  s.name        = "bbq"
  s.version     = Bbq::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paweł Pacana"]
  s.email       = ["pawel.pacana@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Acceptance testing philosophy for grown-ups}
  s.description = %q{Objected oriented acceptance testing using personas and events.}

  s.rubyforge_project = "bbq"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

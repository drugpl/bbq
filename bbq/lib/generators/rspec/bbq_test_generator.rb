module Rspec
  class BbqTestGenerator < Rails::Generators::NamedBase
    source_root Bbq.root.join("lib/generators/rspec/templates")

    def create_test
      template "bbq_spec.rb", "spec/acceptance/#{name.underscore}_spec.rb"
    end
  end
end

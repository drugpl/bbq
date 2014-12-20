module Rspec
  class BbqTestGenerator < Rails::Generators::NamedBase
    source_root File.expand_path(File.join(File.dirname(__FILE__), '../rspec/templates'))

    def create_test
      template "bbq_spec.rb", "spec/acceptance/#{name.underscore}_spec.rb"
    end
  end
end

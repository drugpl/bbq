module TestUnit
  class BbqTestGenerator < Rails::Generators::NamedBase
    source_root File.expand_path(File.join(File.dirname(__FILE__), '../test_unit/templates'))

    def create_test
      template "bbq_test_case.rb", "test/acceptance/#{name.underscore}_test.rb"
    end
  end
end

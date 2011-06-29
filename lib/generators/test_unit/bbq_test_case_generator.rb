module TestUnit
  class BbqTestCaseGenerator < Rails::Generators::NamedBase
    source_root Bbq.root.join("lib/generators/test_unit/templates")

    def create_test
      template "bbq_test_case.rb", "test/acceptance/#{name.underscore}_test.rb"
    end
  end
end

require 'bbq/generator'

module Bbq
  class TestGenerator < Rails::Generators::NamedBase
    include Bbq::Generator

    def create_test
      template "bbq_#{test_framework_short}.rb", "#{test_root}/#{name.underscore}_test.rb"
    end
  end
end

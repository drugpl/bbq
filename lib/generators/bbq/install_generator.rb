require 'bbq/generator'

module Bbq
  class InstallGenerator < Rails::Generators::Base
    include Bbq::Generator

    def create_directory
      empty_directory test_root
    end

    def generate_test_user
      empty_directory support_root
      template "test_user.rb", "#{support_root}/test_user.rb"
    end

    def show_readme
      readme "README.#{test_framework_short}" if behavior == :invoke
    end
  end
end

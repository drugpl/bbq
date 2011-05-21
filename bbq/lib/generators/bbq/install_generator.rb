module Bbq
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    class_option :test_framework, :alias => "-t", :type => :string, :default => "test_unit", :desc => "Test framework to be invoked"

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

    private
    def test_framework_short
      case options.test_framework
      when :test_unit then 'test'
      end
    end

    def test_root
      "#{test_framework_short}/acceptance"
    end

    def support_root
      "#{test_root}/support"
    end
  end
end

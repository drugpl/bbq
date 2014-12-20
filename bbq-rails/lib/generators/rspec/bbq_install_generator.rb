module Rspec
  class BbqInstallGenerator < Rails::Generators::Base
    source_root File.expand_path(File.join(File.dirname(__FILE__), '../rspec/templates'))

    def create_directory
      empty_directory "spec/acceptance"
    end

    def generate_test_user
      empty_directory "spec/support"
      template "test_user.rb", "spec/support/test_user.rb"
    end

    def show_readme
      readme "README" if behavior == :invoke
    end
  end
end

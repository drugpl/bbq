module TestUnit
  class BbqInstallGenerator < Rails::Generators::Base
    source_root Bbq.root.join("lib/generators/test_unit/templates")

    def create_directory
      empty_directory "test/acceptance"
    end

    def generate_test_user
      empty_directory "test/acceptance/support"
      template "test_user.rb", "test/acceptance/support/test_user.rb"
    end

    def show_readme
      readme "README" if behavior == :invoke
    end
  end
end

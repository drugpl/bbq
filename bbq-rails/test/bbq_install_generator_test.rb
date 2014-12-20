require "test_helper"
require "rails/generators/test_case"
require "generators/bbq/rails/install_generator"

class BbqInstallGeneratorTest < Rails::Generators::TestCase
  destination File.expand_path(File.join(File.dirname(__FILE__), '../tmp'))
  setup :prepare_destination

  tests Bbq::Rails::InstallGenerator

  def test_creating_test_unit_test_directories
    run_generator %w(-t test_unit)

    assert_directory "test/acceptance"
    assert_directory "test/support"
  end

  def test_creating_rspec_test_directories
    run_generator %w(-t rspec)

    assert_directory "spec/acceptance"
    assert_directory "spec/support"
  end

  def test_creating_test_unit_test_user_stub
    run_generator %w(-t test_unit)

    assert_file "test/support/test_user.rb", /class TestUser < Bbq::TestUser/
  end

  def test_creating_rspec_test_user_stub
    run_generator %w(-t rspec)

    assert_file "spec/support/test_user.rb", /class TestUser < Bbq::TestUser/
  end
end

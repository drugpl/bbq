require "test_helper"
require "generators/bbq/install_generator"

class BbqInstallGeneratorTest < Rails::Generators::TestCase
  destination Bbq.root.join("tmp")
  setup :prepare_destination

  tests Bbq::InstallGenerator

  def test_creating_test_unit_test_directories
    run_generator %w(-t test_unit)

    assert_directory "test/acceptance"
    assert_directory "test/acceptance/support"
  end

  def test_creating_test_unit_test_user_stub
    run_generator %w(-t test_unit)

    assert_file "test/acceptance/support/test_user.rb", /class TestUser < Bbq::TestUser/
    assert_file "test/acceptance/support/test_user.rb", /require "test_helper"/
  end
end

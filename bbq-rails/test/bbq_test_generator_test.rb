require "test_helper"
require "rails/generators/test_case"
require "generators/bbq/test_generator"

class BbqTestGeneratorTest < ::Rails::Generators::TestCase
  destination File.expand_path(File.join(File.dirname(__FILE__), '../tmp'))
  setup :prepare_destination

  tests Bbq::TestGenerator

  def test_creating_test_unit_feature_file
    run_generator %w(MySuperThing -t test_unit)

    assert_file "test/acceptance/my_super_thing_test.rb", /class MySuperThingTest < Bbq::TestCase/
    assert_file "test/acceptance/my_super_thing_test.rb", /require "test_helper"/
  end

  def test_creating_rspec_feature_file
    run_generator %w(MySuperThing -t rspec)

    assert_file "spec/acceptance/my_super_thing_spec.rb", /feature "My super thing" do/
    assert_file "spec/acceptance/my_super_thing_spec.rb", /require "spec_helper"/
  end
end

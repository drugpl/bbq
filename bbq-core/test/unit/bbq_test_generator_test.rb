require "test_helper"
require "generators/bbq/test_generator"

class BbqTestGeneratorTest < Rails::Generators::TestCase
  destination Bbq.root.join("tmp")
  setup :prepare_destination

  tests Bbq::TestGenerator

  def test_creating_test_unit_feature_file
    run_generator %w(MySuperThing -t test_unit)

    assert_file "test/acceptance/my_super_thing_test.rb", /class MySuperThingTest < Bbq::TestCase/
    assert_file "test/acceptance/my_super_thing_test.rb", /require "test_helper"/
  end
end

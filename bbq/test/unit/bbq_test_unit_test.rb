require 'test_helper'

class BbqTestUnitTest < Test::Unit::TestCase
  include CommandHelper

  def test_dsl
    create_file 'test/dummy/test/acceptance/dsl_test.rb', <<-TESTCASE
      require 'test_helper'
      require 'bbq/test'

      class DslTest < Bbq::TestCase
        background do
          @a = 1
        end

        background :second_ivar

        scenario "valid" do
          assert_equal 3, @a + @b
        end

        def second_ivar
          @b = 2
        end
      end
    TESTCASE

    run_cmd 'ruby -Ilib -Itest/dummy/test test/dummy/test/acceptance/dsl_test.rb'
    assert_match /1 tests, 1 assertions, 0 failures, 0 errors/, output
  end
end

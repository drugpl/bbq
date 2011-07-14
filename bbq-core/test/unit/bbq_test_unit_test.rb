require 'test_helper'

class BbqTestUnitTest < Test::Unit::TestCase
  include CommandHelper

  def test_sinatra
    create_file 'test/dope/test/acceptance/root_path_test.rb', <<-TESTCASE
      require 'app'
      require 'bbq/test'

      class DopeAppRootTest < Bbq::TestCase
        FAILED_ASSERTION = RUBY_VERSION < "1.9" ? Test::Unit::AssertionFailedError : MiniTest::Assertion

        background do
          Capybara.app = ::Dope::App
        end

        scenario "user see '/' page" do
          user = Bbq::TestUser.new
          user.visit "/"
          user.see!("BBQ supports sinatra")
          assert user.see?("BBQ supports sinatra")

          assert_raises(FAILED_ASSERTION) { user.see!("blah") }
          assert_raises(FAILED_ASSERTION) { user.not_see!("BBQ supports sinatra") }

          assert_equal 3, user.instance_variable_get(:@_assertions)
        end
      end
    TESTCASE

    run_cmd 'ruby -Itest/dope -Itest/dope/test test/dope/test/acceptance/root_path_test.rb'
    assert_match /1 tests, 4 assertions, 0 failures, 0 errors/, output
  end

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

  def test_implicit_user_eyes
    create_file 'test/dummy/test/acceptance/implicit_user_eyes_test.rb', <<-TESTUNIT
      require 'test_helper'
      require 'bbq/test'

      FAILED_ASSERTION = RUBY_VERSION < "1.9" ? Test::Unit::AssertionFailedError : MiniTest::Assertion

      class ImplicitUserEyesTest < Bbq::TestCase
        scenario 'should see welcome text' do
          user = Bbq::TestUser.new
          user.visit "/miracle"
          user.see!("MIRACLE")
          user.not_see!("BBQ")

          assert_raises(FAILED_ASSERTION) { user.see!("BBQ") }
          assert_raises(FAILED_ASSERTION) { user.not_see!("MIRACLE") }
        end
      end
    TESTUNIT

    run_cmd 'ruby -Ilib -Itest/dummy/test test/dummy/test/acceptance/implicit_user_eyes_test.rb'
    assert_match /1 tests, 2 assertions, 0 failures, 0 errors/, output
  end
end

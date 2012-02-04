require 'test_helper'

class BbqTestUnitTest < Test::Unit::TestCase
  include CommandHelper

  def test_sinatra
    create_file 'test/dope/test/acceptance/root_path_test.rb', <<-TESTCASE
      require 'app'
      require 'bbq/test_unit'
      require 'bbq/test_user'

      class DopeAppRootTest < Bbq::TestCase
        FAILED_ASSERTION = RUBY_VERSION < "1.9" ? Test::Unit::AssertionFailedError : MiniTest::Assertion

        background do
          Bbq.app = ::Dope::App
        end

        scenario "user see '/' page" do
          user = Bbq::TestUser.new
          user.visit "/"
          user.see!("BBQ supports sinatra")
          assert user.see?("BBQ supports sinatra")

          assert_raises(FAILED_ASSERTION) { user.see!("blah") }
          assert_raises(FAILED_ASSERTION) { user.not_see!("BBQ supports sinatra") }
        end
      end
    TESTCASE

    run_cmd 'ruby -Itest/dope -Itest/dope/test test/dope/test/acceptance/root_path_test.rb'
    assert_match /1 tests, 3 assertions, 0 failures, 0 errors/, output
  end

  def test_dsl
    create_file 'test/dummy/test/acceptance/dsl_test.rb', <<-TESTCASE
      require 'test_helper'
      require 'bbq/test_unit'

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
      require 'bbq/test_unit'
      require 'bbq/test_user'

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

  def test_api_client
    create_file 'test/dummy/test/acceptance/api_test.rb', <<-TESTUNIT
      require 'test_helper'
      require 'bbq/test_unit'
      require 'bbq/test_client'

      class ApiTest < Bbq::TestCase
        scenario 'client fetches the rainbow as JSON' do
          client = Bbq::TestClient.new(:headers => { 'HTTP_ACCEPT' => 'application/json' })
          client.get "/rainbow" do |response|
            assert_equal 200, response.status
            assert_match "application/json", response.headers["Content-Type"]
            assert_equal 7, response.body["colors"]
            assert_equal true, response.body["wonderful"]
          end
        end

        scenario 'client fetches the rainbow as JSON with version' do
          client = Bbq::TestClient.new(:headers => { 'HTTP_ACCEPT' => 'application/vnd.magic+json; version=2' })
          client.get "/rainbow" do |response|
            assert_equal 200, response.status
            assert_match "application/vnd.magic+json; version=2", response.headers["Content-Type"]
            assert_equal 7, response.body["colors"]
            assert_equal true, response.body["wonderful"]
          end
        end

        scenario 'client fetches the rainbow as YAML' do
          client = Bbq::TestClient.new(:headers => { 'HTTP_ACCEPT' => 'application/x-yaml' })
          client.get "/rainbow" do |response|
            assert_equal 200, response.status
            assert_match "application/x-yaml", response.headers["Content-Type"]
            assert_equal 7, response.body["colors"]
            assert_equal true, response.body["wonderful"]
          end
        end

        scenario 'client extended by role gets the rainbow' do
          class Bbq::TestClient
            module HappyUnicorn
              def get_rainbow(*args)
                get "/rainbow", *args
              end
            end
          end

          client = Bbq::TestClient.new(:headers => { 'HTTP_ACCEPT' => 'application/json' })
          client.roles(:happy_unicorn)
          response = client.get_rainbow
          assert_equal 200, response.status
          assert_equal 7, response.body["colors"]
        end
      end
    TESTUNIT

    run_cmd 'ruby -Ilib -Itest/dummy/test test/dummy/test/acceptance/api_test.rb'
    assert_match /4 tests, 14 assertions, 0 failures, 0 errors/, output
  end
end

require 'test_helper'

class BbqRspecTest < Test::Unit::TestCase
  include CommandHelper

  def setup
    @log_path = 'test/dummy/log/test_driver.log'
  end

  def test_dsl
    create_file 'test/dummy/spec/acceptance/dsl_spec.rb', <<-RSPEC
      require 'spec_helper'
      require 'bbq/rspec'

      feature 'dsl' do
        background do
          @a = 1
        end

        scenario 'valid' do
          @a.should == 1
        end
      end
    RSPEC

    run_cmd 'rspec -Itest/dummy/spec test/dummy/spec/acceptance/dsl_spec.rb'
    assert_match /1 example, 0 failures/, output
  end

  def test_capybara_matchers
    create_file 'test/dummy/spec/acceptance/capybara_matchers_spec.rb', <<-RSPEC
      require 'spec_helper'
      require 'bbq/rspec'

      feature 'capybara matchers' do
        scenario 'should see welcome text' do
          user = Bbq::TestUser.new
          user.visit "/miracle"
          user.page.should have_content("MIRACLE")
          user.should have_no_content("BBQ")
        end
      end
    RSPEC

    run_cmd 'rspec -Itest/dummy/spec test/dummy/spec/acceptance/capybara_matchers_spec.rb'
    assert_match /1 example, 0 failures/, output
  end

  def test_bbq_matchers
    create_file 'test/dummy/spec/acceptance/bbq_matchers_spec.rb', <<-RSPEC
      require 'spec_helper'
      require 'bbq/rspec'

      feature 'bbq matchers' do
        scenario 'should see welcome text' do
          user = Bbq::TestUser.new
          user.visit "/miracle"
          user.should see("MIRACLE")
          user.should not_see("BBQ")
        end
      end
    RSPEC

    run_cmd 'rspec -Itest/dummy/spec test/dummy/spec/acceptance/bbq_matchers_spec.rb'
    assert_match /1 example, 0 failures/, output
  end

  def test_implicit_user_eyes
    create_file 'test/dummy/spec/acceptance/implicit_user_eyes_spec.rb', <<-RSPEC
      require 'spec_helper'
      require 'bbq/rspec'

      feature 'implicit user eyes' do
        scenario 'should see welcome text' do
          user = Bbq::TestUser.new
          user.visit "/miracle"
          user.see!("MIRACLE")
          user.not_see!("BBQ")

          lambda { user.see!("BBQ") }.should raise_error
          lambda { user.not_see!("MIRACLE") }.should raise_error
        end
      end
    RSPEC

    run_cmd 'rspec -Itest/dummy/spec test/dummy/spec/acceptance/implicit_user_eyes_spec.rb'
    assert_match /1 example, 0 failures/, output
  end

  def test_session_pool
    create_file 'test/dummy/spec/acceptance/session_pool_spec.rb', <<-RSPEC
      require 'spec_helper'
      require 'bbq/rspec'
      require 'driver_factory'

      Factory = DriverFactory.new('#{@log_path}')
      Capybara.register_driver :bbq do |app|
        Factory.get_driver(app)
      end
      Capybara.default_driver = :bbq

      feature 'session pool' do
        scenario 'alice visits page' do
          Factory.drivers_clean?.should be_true
          alice = Bbq::TestUser.new
          alice.visit "/miracle"
          Factory.drivers_clean?.should be_false
        end

        scenario 'both alice and bob visit page' do
          Factory.drivers_clean?.should be_true
          alice = Bbq::TestUser.new
          bob   = Bbq::TestUser.new
          alice.visit "/miracle"
          bob.visit "/miracle"
          Factory.drivers_clean?.should be_false
        end

        scenario 'bob visits page' do
          Factory.drivers_clean?.should be_true
          bob  = Bbq::TestUser.new
          bob.visit "/miracle"
          Factory.drivers_clean?.should be_false
        end
      end
    RSPEC

    run_cmd 'rspec -Itest/dummy/spec -Itest/support test/dummy/spec/acceptance/session_pool_spec.rb'
    assert_match /3 examples, 0 failures/, output
    drivers_created = File.readlines(@log_path).size
    assert_equal 2, drivers_created
  end

  def test_without_session_pool
    create_file 'test/dummy/spec/acceptance/without_session_pool_spec.rb', <<-RSPEC
      require 'spec_helper'
      require 'bbq/test'
      require 'driver_factory'

      Factory = DriverFactory.new('#{@log_path}')
      Capybara.register_driver :bbq do |app|
        Factory.get_driver(app)
      end
      Capybara.default_driver = :bbq

      feature 'without session pool' do
        scenario 'alice visits page' do
          alice = Bbq::TestUser.new(:pool => false)
          alice.visit "/miracle"
        end

        scenario 'both alice and bob visit page' do
          alice  = Bbq::TestUser.new(:pool => false)
          bob    = Bbq::TestUser.new(:pool => false)

          alice.visit "/miracle"
          bob.visit "/miracle"
        end

        scenario 'bob visits page' do
          bob  = Bbq::TestUser.new(:pool => false)
          bob.visit "/miracle"
        end

      end
    RSPEC

    run_cmd 'rspec -Itest/dummy/spec -Itest/support test/dummy/spec/acceptance/without_session_pool_spec.rb'
    assert_match /3 examples, 0 failures/, output
    drivers_created = File.readlines(@log_path).size
    assert_equal 4, drivers_created
  end
end

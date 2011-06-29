require 'test_helper'

class BbqRspecTest < Test::Unit::TestCase
  include CommandHelper

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
end

require 'test_helper'

class BbqRspecTest < Test::Unit::TestCase
  include CommandHelper

  def setup
    @log_path = 'test/dummy/log/test_driver.log'
  end

  def test_capybara_matchers
    run_cmd 'bundle exec rspec -Itest/dummy/spec test/dummy/spec/acceptance/capybara_matchers_spec.rb'
    assert_match /1 example, 0 failures/, output
  end

  def test_bbq_matchers
    run_cmd 'bundle exec rspec -Itest/dummy/spec test/dummy/spec/acceptance/bbq_matchers_spec.rb'
    assert_match /2 examples, 0 failures/, output
  end
end

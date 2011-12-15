require 'test_helper'
require 'bbq/test_user'

class BbqSessionPoolTest < Test::Unit::TestCase
  def setup
    Bbq::Session.instance_variable_set(:@pool, nil)
  end

  def test_reuses_sessions
    pool = Bbq::Session::Pool.new
    user1 = Bbq::TestUser.new(:pool => pool).tap { |u| u.page }
    pool.release
    user2 = Bbq::TestUser.new(:pool => pool).tap { |u| u.page }

    assert_same user1.page, user2.page
  end

  def test_has_default_pool
    user1 = Bbq::TestUser.new.tap { |u| u.page }
    Bbq::Session::pool.release
    user2 = Bbq::TestUser.new.tap { |u| u.page }

    assert_same user1.page, user2.page
  end

  def test_without_pool
    user1 = Bbq::TestUser.new(:pool => false).tap { |u| u.page }
    Bbq::Session::pool.release
    user2 = Bbq::TestUser.new(:pool => false).tap { |u| u.page }

    assert_not_same user1.page, user2.page
  end

  def test_pool_returns_correct_driver
    pool = Bbq::Session::Pool.new
    pool.next(:rack_test)
    pool.next(:selenium)
    pool.release

    assert_equal :rack_test, pool.next(:rack_test).mode
  end
end

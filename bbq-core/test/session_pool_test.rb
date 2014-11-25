require 'test_helper'
require 'bbq/core/test_user'

class SessionPoolTest < Minitest::Test

  def setup
    Bbq::Core::Session.instance_variable_set(:@pool, nil)
  end

  def test_reuses_sessions
    pool  = Bbq::Core::Session::Pool.new
    user1 = Bbq::Core::TestUser.new(:pool => pool).tap { |u| u.page }
    pool.release
    user2 = Bbq::Core::TestUser.new(:pool => pool).tap { |u| u.page }

    assert_same user1.page, user2.page
  end

  def test_has_default_pool
    user1 = Bbq::Core::TestUser.new.tap { |u| u.page }
    Bbq::Core::Session::pool.release
    user2 = Bbq::Core::TestUser.new.tap { |u| u.page }

    assert_same user1.page, user2.page
  end

  def test_without_pool
    user1 = Bbq::Core::TestUser.new(:pool => false).tap { |u| u.page }
    Bbq::Core::Session::pool.release
    user2 = Bbq::Core::TestUser.new(:pool => false).tap { |u| u.page }

    refute_same user1.page, user2.page
  end

  def test_pool_returns_correct_driver
    pool = Bbq::Core::Session::Pool.new
    pool.next(:rack_test)
    pool.next(:rack_test_the_other)
    pool.release

    assert_equal :rack_test, pool.next(:rack_test).mode
  end

end

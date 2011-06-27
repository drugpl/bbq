# encoding utf-8

require 'test_helper'
require 'capybara/rails'
require 'bbq/test_user'
require 'bbq/devise'

class TestUser < Bbq::TestUser
  include Bbq::SpicyDevise
end

class BbqDeviseTest < Test::Unit::TestCase

  def teardown
    User.find_by_email(@user.email).try(:destroy)
  end

  def test_user_register
    @user = TestUser.new(self)
    @user.register
    @user.see? "BBQ"
  end

  def test_login_user
    @user = TestUser.new(self)
    @user.register
    @user.logout
    @user.login
    @user.see? "BBQ"
  end

  def test_user_wihout_login
    @user = TestUser.new(self)
    @user.visit @user.root_path
    @user.not_see? "BBQ"
  end
  
end


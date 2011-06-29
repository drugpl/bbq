# encoding utf-8

require 'test_helper'
require 'capybara/rails'
require 'bbq/test_user'
require 'bbq/devise'

class DeviseTestUser < Bbq::TestUser
  include Bbq::Devise
end

class BbqDeviseTest < Test::Unit::TestCase

  def teardown
    User.find_by_email(@user.email).try(:destroy)
  end

  def test_user_register
    @user = DeviseTestUser.new
    @user.register
    @user.see? "BBQ"
  end

  def test_login_user
    @user = DeviseTestUser.new
    @user.register
    @user.logout
    @user.login
    @user.see? "BBQ"
  end

  def test_user_wihout_login
    @user = DeviseTestUser.new
    @user.visit @user.root_path
    @user.not_see? "BBQ"
  end

end


require 'test_helper'
require 'bbq/core/test_user'
require 'bbq/devise'

class DeviseTestUser < Bbq::Core::TestUser
  include Bbq::Devise
end

class BbqDeviseTest < Minitest::Unit::TestCase

  def test_user_register
    user = DeviseTestUser.new
    user.register

    assert user.see?("dummy")
    User.find_by_email(user.email).destroy
  end

  def test_login_user
    user = DeviseTestUser.new(:password => 'dupa.8')
    user.register
    user.logout
    user.login

    assert user.see?("dummy")
    User.find_by_email(user.email).destroy
  end

  def test_user_without_login
    user = DeviseTestUser.new
    user.visit user.root_path

    assert user.not_see?("dummy")
  end

end

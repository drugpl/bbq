require 'test_helper'
require 'bbq/test_user'
require 'bbq/devise'

class DeviseTestUser < Bbq::TestUser
  include Bbq::Devise
end

class TestUser < Bbq::TestUser
  module Commenter
    def comment
    end
  end

  module VideoUploader
    def upload
    end
  end

  module CommentModerator
    def moderate
    end
  end
end

class BbqTestUserTest < Test::Unit::TestCase

  def test_capybara_dsl_methods
    user = TestUser.new
    Capybara::Session::DSL_METHODS.each do |m|
      assert user.respond_to?(m)
    end
  end

  def test_roles
    user = TestUser.new
    %w(comment upload moderate).each { |m| assert !user.respond_to?(m) }

    user.roles(:commenter, "comment_moderator")
    %w(comment moderate).each { |m| assert user.respond_to?(m) }
    assert !user.respond_to?(:upload)

    user.roles(:video_uploader)
    %w(comment upload moderate).each { |m| assert user.respond_to?(m) }
  end

  def test_implicit_user_eyes
    @user = DeviseTestUser.new
    @user.register
    assert_raises(FAILED_ASSERTION) { @user.not_see!("BBQ") }
    assert_raises(FAILED_ASSERTION) { @user.see!("MIRACLE") }
    User.find_by_email(@user.email).destroy
  end

  def test_explicit_user_eyes
    @user = DeviseTestUser.new
    @user.register
    assert @user.see?("BBQ")
    assert @user.not_see?("MIRACLE")
    User.find_by_email(@user.email).destroy
  end

end

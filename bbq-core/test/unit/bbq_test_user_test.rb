require 'test_helper'
require 'bbq/test_user'

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

  def test_driver_option
    user = TestUser.new(:driver => :rack_test_the_other)
    assert_equal :rack_test_the_other, user.page.mode
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

  def test_explicit_user_eyes
    @user = TestUser.new
    @user.visit "/miracle"
    assert @user.not_see?("BBQ")
    assert @user.see?("MIRACLE")
  end

  def test_user_eyes_within_scope
    @user = TestUser.new
    @user.visit "/ponycorns"
    assert @user.see?("Pink", :within => "#unicorns")
    assert ! @user.see?("Violet", :within => "#unicorns")
    assert @user.not_see?("Violet", :within => "#unicorns")
    assert ! @user.not_see?("Pink", :within => "#unicorns")

    assert_nothing_raised do
      @user.fill_in "color", :with => "red", :within => "#new_pony"
    end
    assert_raises Capybara::ElementNotFound do
      @user.fill_in "color", :with => "red", :within => "#new_unicorn"
    end

    assert_nothing_raised do
      @user.click_link "More ponycorns"
    end
  end

end

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
    user = TestUser.new(self)
    Capybara::Session::DSL_METHODS.each do |m|
      assert user.respond_to?(m)
    end
  end

  def test_roles
    user = TestUser.new(self)
    %w(comment upload moderate).each { |m| assert !user.respond_to?(m) }

    user.roles(:commenter, "comment_moderator")
    %w(comment moderate).each { |m| assert user.respond_to?(m) }
    assert !user.respond_to?(:upload)

    user.roles(:video_uploader)
    %w(comment upload moderate).each { |m| assert user.respond_to?(m) }
  end
end

require 'test_helper'
require 'bbq/core/test_user'


def text(output)
end

def html(output)
  ->{ ['200', {'Content-Type' => 'text/html'}, [output]] }
end

TestApp = Rack::Builder.new do
  map '/' do
    run ->(env) { ['200', {'Content-Type' => 'text/plain'}, ['BBQ']] }
  end

  map '/miracle' do
    run ->(env) { ['200', {'Content-Type' => 'text/plain'}, ['MIRACLE']] }
  end

  map '/ponycorns' do
    run ->(env) { ['200', {'Content-Type' => 'text/html'}, [<<HTML
<ul id="unicorns">
  <li>Pink</li>
</ul>
<ul id="ponies">
  <li>Violet</li>
</ul>
<div id="new_pony">
  <input type="text" name="color" value="" />
</div>
<a href="#">More ponycorns</a>
HTML
    ]] }
  end
end


class TestUser < Bbq::Core::TestUser
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

class TestUserTest < Minitest::Test

  def setup
    Bbq::Core.app = TestApp
  end

  def teardown
    Bbq::Core.app = nil
  end

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

    @user.fill_in "color", :with => "red", :within => "#new_pony"
    assert_raises Capybara::ElementNotFound do
      @user.fill_in "color", :with => "red", :within => "#new_unicorn"
    end
    @user.click_link "More ponycorns"
  end

end

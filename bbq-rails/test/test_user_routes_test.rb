require 'test_helper'
require 'bbq/core/test_user'
require 'bbq/rails/routes'

class TestUserRoutesTest < TestCase
  class TestUserWithRoutes < Bbq::Core::TestUser
    include ::Bbq::Rails::Routes

    def visit_test_page
      visit(root_url)
    end
  end

  def test_routes_integration
    user = TestUserWithRoutes.new
    user.visit_test_page

    assert user.has_content?('dummy')
  end

end

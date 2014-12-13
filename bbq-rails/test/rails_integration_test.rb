require 'test_helper'
require 'bbq/core/test_user'

class RailsIntegration < Minitest::Test

  def test_rails_integration
    user = Bbq::Core::TestUser.new
    user.visit('/')

    assert user.has_content?('dummy')
  end

end

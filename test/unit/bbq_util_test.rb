require 'test_helper'
require 'bbq/util'

class User
  module Commenter
  end
end

module Commenter
end

class BbqUtilTest < Test::Unit::TestCase
  def test_find_module
    user = User.new
    [:commenter, "commenter"].each do |name|
      obj  = Bbq::Util.find_module(name, user)
      assert_equal obj, User::Commenter
    end
  end
end

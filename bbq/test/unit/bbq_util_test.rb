require 'test_helper'
require 'bbq/util'

class User
  module Commenter
  end
end

module Commenter
end

class BbqUtilTest < Test::Unit::TestCase
  
  def test_find_module_in_object
    user = User.new
    [:commenter, "commenter"].each do |name|
      obj  = Bbq::Util.find_module(name, user)
      assert_equal obj, User::Commenter
    end
  end

  def test_find_global_module
    [:commenter, "commenter"].each do |name|
      obj  = Bbq::Util.find_module(name)
      assert_equal obj, ::Commenter
    end
  end

  def test_find_module_in_class
    [:commenter, "commenter"].each do |name|
      obj  = Bbq::Util.find_module(name, User)
      assert_equal obj, User::Commenter
    end
  end

  def test_find_module_in_string_namespace
    [:commenter, "commenter"].each do |name|
      obj  = Bbq::Util.find_module(name, "User")
      assert_equal obj, User::Commenter
    end
  end

end

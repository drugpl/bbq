require 'test_helper'
require 'bbq/util'

class User
  module Commenter
  end
end

module Commenter
end

class BbqUtilTest < Test::Unit::TestCase
  
  def test_find_module_in_object_namespace
    assert_commenter(User.new, User::Commenter)
  end

  def test_find_module_in_class_namespace
    assert_commenter(User, User::Commenter)
  end

  def test_find_module_in_string_namespace
    assert_commenter("User", User::Commenter)
  end

  def test_find_global_module
    assert_commenter(nil, ::Commenter)
  end

  
  private


  def assert_commenter(namespace, result)
    [:commenter, "commenter"].each do |name|
      assert_equal Bbq::Util.find_module(name, namespace), result
    end
  end

end

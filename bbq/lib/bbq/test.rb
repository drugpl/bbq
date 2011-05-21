require 'active_support'
require 'test/unit'
require 'bbq/test_user'

module Bbq
  class TestCase < ActiveSupport::TestCase
    class << self
      alias :scenario :test
      alias :background :setup
    end

    alias :background :setup
  end

  # test/unit specific methods for test_user
  class TestUser
    def see?(*args)
      args.each do |arg|
        env.assert session.has_content?(arg), "Expecting to see \"#{arg}\", text not found."
      end
    end

    def not_see?(*args)
      args.each do |arg|
        env.assert session.has_no_content?(arg), "Found \"#{arg}\", which was unexpected."
      end
    end
  end
end

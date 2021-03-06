require 'bbq/core/session'
require 'test/unit'
require 'test/unit/assertions'
require 'active_support/test_case'

module Bbq
  class TestCase < ActiveSupport::TestCase
    class << self
      alias :scenario :test
      alias :background :setup
    end

    alias :background :setup

    teardown do
      Bbq::Core::Session.pool.release
    end
  end

  class TestUser
    include Test::Unit::Assertions

    def see!(*args)
      args.each do |arg|
        assert has_content?(arg), "Expecting to see \"#{arg}\", text not found."
      end
    end

    def not_see!(*args)
      args.each do |arg|
        assert has_no_content?(arg), "Found \"#{arg}\", which was unexpected."
      end
    end
  end
end

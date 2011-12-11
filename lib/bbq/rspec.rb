require 'rspec/core'
require 'bbq/test_user'
require 'capybara/rspec/matchers'

module Bbq
  module RSpecFeature
    def self.included(base)
      base.instance_eval do
        alias :background :before
        alias :scenario :it
      end
    end
  end

  module RSpecMatchers
    class TestUserEyes
      def initialize(negative, *args)
        @args, @negative = args, negative
      end

      def matches?(actual)
        @negative ? actual.not_see?(*@args) : actual.see?(*@args)
      end

      def failure_message_for_should
        "expected to #{@negative ? negative_description : positive_description}"
      end

      def failure_message_for_should_not
        "expected to #{@negative ? positive_description : negative_description}"
      end

      def description
        @negative ? negative_description : positive_description
      end

      protected

      def negative_description
        "not see any of the following: #{@args.join(', ')}"
      end

      def positive_description
        "see all of the following: #{@args.join(', ')}"
      end
    end

    def see(*args)
      TestUserEyes.new(false, *args)
    end

    def not_see(*args)
      TestUserEyes.new(true, *args)
    end
  end

  class TestUser
    include RSpec::Matchers
    include Capybara::RSpecMatchers
    include Bbq::RSpecMatchers

    def see!(*args)
      args.each do |arg|
        page.should have_content(arg)
      end
    end

    def not_see!(*args)
      args.each do |arg|
        page.should have_no_content(arg)
      end
    end
  end
end

def self.feature(*args, &block)
  options = if args.last.is_a?(Hash) then args.pop else {} end
  options[:type] = :acceptance
  options[:caller] ||= caller
  args.push(options)

  describe(*args, &block)
end

RSpec.configuration.include Bbq::RSpecFeature, :type => :acceptance

RSpec.configure do |config|
  config.include Capybara::RSpecMatchers, :type => :acceptance
  config.include Bbq::RSpecMatchers, :type => :acceptance

  config.after :each, :type => :acceptance do
    Bbq::Session.pool.release
  end
end

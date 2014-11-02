require 'bbq'
require 'bbq/session'
require 'rspec/core'
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
    module V2
      extend ::RSpec::Matchers::DSL

      matcher :see do |text|
        chain :within do |locator|
          @locator = locator
        end

        match_for_should do |page|
          if @locator
            page.within(@locator) do
              page.see? text
            end
          else
            page.see? text
          end
        end

        match_for_should_not do |page|
          if @locator
            page.within(@locator) do
              page.not_see? text
            end
          else
            page.not_see? text
          end
        end

        failure_message_for_should do |page|
          body = if @locator
                   page.find(@locator).text
                 else
                   page.body
                 end
          "expected to see #{text} in #{body}"
        end

        failure_message_for_should_not do |page|
          body = if @locator
                   page.find(@locator).text
                 else
                   page.body
                 end
          "expected not to see #{text} in #{body}"
        end
      end
    end

    module V3
      extend ::RSpec::Matchers::DSL

      matcher :see do |text|
        chain :within do |locator|
          @locator = locator
        end

        match do |page|
          if @locator
            page.within(@locator) do
              page.see? text
            end
          else
            page.see? text
          end
        end

        match_when_negated do |page|
          if @locator
            page.within(@locator) do
              page.not_see? text
            end
          else
            page.not_see? text
          end
        end

        failure_message do |page|
          body = if @locator
                   page.find(@locator).text
                 else
                   page.body
                 end
          "expected to see #{text} in #{body}"
        end

        failure_message_when_negated do |page|
          body = if @locator
                   page.find(@locator).text
                 else
                   page.body
                 end
          "expected not to see #{text} in #{body}"
        end
      end
    end

    def self.rspec_matchers_module
      major_rspec_version, _ = RSpec::Core::Version::STRING.split('.')
      self.const_get("V#{major_rspec_version}")
    end

    include rspec_matchers_module
  end

  class TestUser
    include RSpec::Matchers
    include Capybara::RSpecMatchers
    include Bbq::RSpecMatchers

    def see!(*args)
      see?(*args).should be_true
    end

    def not_see!(*args)
      not_see?(*args).should be_true
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

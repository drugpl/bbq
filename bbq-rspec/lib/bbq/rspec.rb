require "bbq/core"
require "bbq/core/test_user"
require "bbq/rspec/version"
require "bbq/rspec/matchers"
require "rspec/core"
require "capybara/rspec/matchers"

module Bbq
  module RSpec
    module Feature
      def self.included(base)
        base.metadata[:type]   = :acceptance
        base.metadata[:caller] = caller

        base.instance_eval do
          alias :background :before
          alias :scenario :it
          alias :feature :describe
        end
      end
    end

    class TestUser
      include Capybara::RSpecMatchers
      include ::Bbq::RSpec::Matchers
      include ::RSpec::Matchers
    end

    ::RSpec.configure do |config|
      if Gem::Version.new(::RSpec::Core::Version::STRING) >= Gem::Version.new('2.99')
        config.include Feature, :type => :acceptance, :file_path => %r{spec/acceptance}
      else
        config.include Feature, :type => :acceptance, :example_group => {:file_path => %r{spec/acceptance}}
      end
      config.include Matchers
      config.after :each, :type => :acceptance do
        ::Bbq::Session.pool.release
      end
    end
  end
end

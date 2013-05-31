require 'active_support/concern'
require 'bbq'
require 'bbq/session'
require 'rspec/core'
require 'capybara/rspec/matchers'
require 'bbq/rspec/matchers'

module Bbq
  module RSpecFeature
    extend ActiveSupport::Concern

    ::RSpec.configure do |config|
      config.include self,
                     :type => :acceptance,
                     :example_group => {:file_path => %r(spec/acceptance)}
      config.include Bbq::RSpec::Matchers
      config.after :each, :type => :acceptance do
        Bbq::Session.pool.release
      end
    end

    included do
      metadata[:type]     = :acceptance
      metadata[:caller] ||= caller

      instance_eval do
        alias :background :before
        alias :scenario :it
        alias :feature :describe
      end
    end
  end

  class TestUser
    include ::RSpec::Matchers
    include Capybara::RSpecMatchers
    include Bbq::RSpec::Matchers
  end
end

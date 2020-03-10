require 'bbq/core/session'
require 'bbq/core/roles'
require 'bbq/core/test_user/capybara_dsl'
require 'bbq/core/test_user/eyes'
require 'bbq/core/test_user/within'

module Bbq
  module Core
    class TestUser
      include Bbq::Core::TestUser::CapybaraDsl
      include Bbq::Core::TestUser::Eyes
      include Bbq::Core::TestUser::Within
      include Bbq::Core::Roles

      attr_reader :options

      def initialize(options = {})
        @options = default_options.merge(options)
      end

      def default_options
        {
          :pool   => Bbq::Core::Session.pool,
          :driver => ::Capybara.default_driver
        }
      end

      def page
        @page ||= options[:session] || Bbq::Core::Session.next(:driver => options[:driver], :pool => options[:pool])
      end
    end
  end
end

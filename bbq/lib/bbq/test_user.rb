require 'capybara/rails' if Bbq.rails?
require 'capybara/dsl'
require 'securerandom'
require 'bbq/session'
require 'bbq/util'
require 'bbq/test_user/capybara_dsl'
require 'bbq/test_user/eyes'
require 'bbq/test_user/within'

module Bbq
  class TestUser
    if Bbq.rails?
      include ActionDispatch::Routing::UrlFor
      include Rails.application.routes.url_helpers
      include ActionDispatch::Routing::RouteSet::MountedHelpers unless Rails.version < "3.1"
    end
    include Bbq::TestUser::CapybaraDsl
    include Bbq::TestUser::Eyes
    include Bbq::TestUser::Within

    attr_reader :options

    def initialize(options = {})
      @options = default_options.merge(options)
    end

    def default_options
      {
        :pool => Bbq::Session.pool,
        :driver => ::Capybara.default_driver
      }
    end

    def page
      @page ||= options[:session] || Bbq::Session.next(:driver => options[:driver], :pool => options[:pool])
    end

    def roles(*names)
      names.each do |name|
        module_obj = Bbq::Util.find_module(name, self)
        self.extend(module_obj)
      end
    end
  end
end

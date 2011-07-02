require 'capybara/rails'
require 'capybara/dsl'
require 'securerandom'
require 'bbq/util'
require 'bbq/test_user/eyes'

module Bbq
  class TestUser
    include ActionDispatch::Routing::UrlFor
    include Rails.application.routes.url_helpers
    include ActionDispatch::Routing::RouteSet::MountedHelpers unless Rails.version < "3.1"
    include Capybara::DSL
    include Bbq::TestUser::Eyes

    attr_reader :options

    def initialize(options = {})
      @session_name = options.delete(:session_name)
      @current_driver = options.delete(:driver)
      @options = options
    end

    def page
      Capybara.using_driver(current_driver) do
        Capybara.using_session(session_name) do
          Capybara.current_session
        end
      end
    end

    # Discuss: Shall we freeze ?
    def session_name
      @session_name ||= SecureRandom.hex(8)
    end

    # Discuss: Shall we freeze ?
    def current_driver
      @current_driver
    end

    def roles(*names)
      names.each do |name|
        module_obj = Bbq::Util.find_module(name, self)
        self.extend(module_obj)
      end
    end
  end
end

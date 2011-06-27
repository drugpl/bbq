require 'capybara/rails'
require 'capybara/dsl'
require 'bbq/util'

module Bbq
  
  class TestUser
    
    include ActionDispatch::Routing::UrlFor
    include Rails.application.routes.url_helpers
    include Capybara::DSL

    attr_reader :options

    def initialize(options = {})
      @session_name = options.delete(:session_name)
      @current_driver = options.delete(:driver)
      @options = options

      @@_callbacks.each do |callback|
        callback[:extension].send(callback[:method], self)
      end
    end

    def page
      Capybara.using_session(session_name) do
        Capybara.current_session
      end
    end

    def session_name
      @session_name ||= ActiveSupport::SecureRandom.hex(8)
    end

    def roles(*names)
      names.each do |name|
        module_obj = Bbq::Util.find_module(name, self)
        self.extend(module_obj)
      end
    end

    def self.add_callback(extension, method=:init)
      @@_callbacks ||= []
      @@_callbacks << {:extension => extension, :method => method}
    end

  end

end

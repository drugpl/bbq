require 'capybara/rails'
require 'capybara/dsl'
require 'securerandom'
require 'bbq/util'

module Bbq

  class TestUser

    include ActionDispatch::Routing::UrlFor
    include Rails.application.routes.url_helpers
    include ActionDispatch::Routing::RouteSet::MountedHelpers unless Rails.version < "3.1"
    include Capybara::DSL

    attr_reader :options

    class << self
      attr_accessor :callbacks
    end

    def initialize(options = {})
      @session_name = options.delete(:session_name)
      @current_driver = options.delete(:driver)
      @options = options

      self.class.callbacks && self.class.callbacks.each do |callback|
        callback[:extension].send(callback[:method], self)
      end
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

    def self.add_callback(extension, method=:init)
      self.callbacks ||= []
      self.callbacks << {:extension => extension, :method => method}
    end

    def see?(*args)
      args.all? { |arg| has_content?(arg) }
    end

    def not_see?(*args)
      args.all? { |arg| has_no_content?(arg) }
    end

  end

end

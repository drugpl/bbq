require 'bbq/roles'

module Bbq
  class TestClient
    include Bbq::Roles

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    HTTP_METHODS = %w(get post put delete)

    HTTP_METHODS.each do |method|
      class_eval <<-RUBY
        def #{method}(path, params = {}, headers = {})
          rack_response = testing_tool.send(:#{method}, path, params, default_headers.merge(headers))
          response = parse_response(rack_response)
          yield response if block_given?
          response
        end
      RUBY
    end

    protected

    def app
      options[:app] || (Rails.application if Bbq.rails?)
    end

    def default_headers
      options[:headers] || {}
    end

    def testing_tool
      @testing_tool ||= RackTest.new(app)
    end

    def parse_response(rack_response)
      case rack_response.headers["Content-Type"]
      when /^application\/(.*\+)?json/
        rack_response.extend(JsonBody)
      when /^application\/(.*\+)?x-yaml/
        rack_response.extend(YamlBody)
      else
        rack_response
      end
    end

    class RackTest
      attr_accessor :app

      def initialize(app)
        self.app = app
      end

      include Rack::Test::Methods
    end

    module JsonBody
      def body
        @parsed_body ||= super.empty?? super : JSON.parse(super)
      end
    end

    module YamlBody
      def body
        @parsed_body ||= YAML.load(super)
      end
    end
  end
end

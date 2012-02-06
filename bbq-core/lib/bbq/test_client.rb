require 'bbq/roles'

module Bbq
  class TestClient
    class UnsupportedMethodError < StandardError; end

    include Bbq::Roles

    def initialize(options = {})
      @options = options
    end

    HTTP_METHODS = %w(get post put delete head options patch)

    HTTP_METHODS.each do |method|
      class_eval <<-RUBY
        def #{method}(path, params = {}, headers = {})
          response = testing_tool.send(:#{method}, path, params, default_headers.merge(headers))
          parsed_response = parse_response(response)
          yield parsed_response if block_given?
          parsed_response
        rescue NoMethodError
          raise UnsupportedMethodError, "Your testing tool does not support #{method.upcase} method"
        end
      RUBY
    end

    protected

    def app
      @options[:app] || Bbq.app
    end

    def default_headers
      @options[:headers] || {}
    end

    def testing_tool
      @testing_tool ||= RackTest.new(app)
    end

    def parse_response(response)
      case response.headers["Content-Type"]
      when /^application\/(.*\+)?json/
        response.extend(JsonBody)
      when /^application\/(.*\+)?x-yaml/
        response.extend(YamlBody)
      else
        response
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

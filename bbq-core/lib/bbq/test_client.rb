module Bbq
  class TestClient
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    HTTP_METHODS = %w(get post put delete)

    HTTP_METHODS.each do |method|
      class_eval <<-RUBY
        def #{method}(path, params = {}, headers = {})
          response = JsonResponse.new(testing_tool.send(:#{method}, path, params, default_headers.merge(headers)))
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

    class RackTest
      attr_accessor :app

      def initialize(app)
        self.app = app
      end

      include Rack::Test::Methods
    end

    class JsonResponse
      attr_reader :status, :headers, :response

      def initialize(response)
        @response = response
        @status   = response.status
        @headers  = response.headers
      end

      def body
        @body ||= begin
          @response.body.empty?? @response.body : JSON.parse(@response.body)
        end
      end
    end
  end
end

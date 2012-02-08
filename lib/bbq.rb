require 'pathname'

module Bbq
  class << self
    def root
      @root ||= Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
    end

    def rails?
      defined?(::Rails)
    end

    def railtie_support?
      rails? && ::Rails::VERSION::MAJOR >= 3
    end

    attr_accessor :app
  end
end

require 'bbq/railtie' if Bbq.railtie_support?

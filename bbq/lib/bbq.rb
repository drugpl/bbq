require 'pathname'

module Bbq
  extend self

  def root
    @root ||= Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
  end

  def rails?
    defined?(::Rails)
  end

  attr_accessor :app
end

require 'bbq/railtie' if Bbq.rails?

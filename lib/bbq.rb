require 'pathname'

module Bbq
  def self.root
    @root ||= Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
  end

  def self.rails?
    defined?(::Rails)
  end
end

require 'bbq/railtie' if Bbq.rails?
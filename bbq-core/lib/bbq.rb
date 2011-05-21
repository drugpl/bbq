require 'bbq/railtie' if defined?(Rails)

module Bbq
  def self.root
    @root ||= Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
  end
end

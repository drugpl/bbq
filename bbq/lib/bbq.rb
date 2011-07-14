require 'pathname'

module Bbq
  def self.root
    @root ||= Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
  end

  def self.rails?
    defined?(::Rails)
  end

  def self.app
    Capybara.app
  end

  def self.app=(new_app)
    Capybara.app=(new_app)
  end
end

require 'bbq/railtie' if Bbq.rails?
require 'minitest/autorun'
require 'bbq/rails'
require 'action_controller/railtie'

TestCase = begin
  Minitest::Test
rescue NameError
  MiniTest::Unit::TestCase
end

class DummyApplication < ::Rails::Application
  config.eager_load   = false
  config.secret_token = SecureRandom.hex(30)
end

class DummyController < ActionController::Base
  def index
    render text: 'dummy'
  end
end

DummyApplication.initialize!
DummyApplication.routes.draw { root to: 'dummy#index' }
DummyApplication.routes.default_url_options[:host] = 'example.com'

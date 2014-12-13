require 'minitest/autorun'
require 'bbq/rails'
require 'action_controller/railtie'

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

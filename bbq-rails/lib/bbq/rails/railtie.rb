require 'rails/railtie'
require 'rails/generators'
require 'bbq/core'

module Bbq
  module Rails
    class Railtie < ::Rails::Railtie

      initializer "bqq.set_app" do
        Bbq::Core.app = ::Rails.application
      end

      rake_tasks do
        load File.expand_path(File.join(File.dirname(__FILE__), '../lib/tasks/bbq.rake'))
      end

      helper_generators = %w(test_unit rspec).flat_map do |test_framework|
        ["#{test_framework}:bbq_test", "#{test_framework}:bbq_install"]
      end
      ::Rails::Generators.hide_namespaces *helper_generators

    end
  end
end

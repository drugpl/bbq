require 'rails/generators'

module Bbq
  class Railtie < Rails::Railtie
    initializer "bqq.set_app" do
      Bbq.app = Rails.application
    end

    rake_tasks do
      load Bbq.root.join("lib/tasks/bbq.rake")
    end

    helper_generators = %w(test_unit rspec).collect do |test_framework|
      ["#{test_framework}:bbq_test", "#{test_framework}:bbq_install"]
    end.flatten

    Rails::Generators.hide_namespaces *helper_generators
  end
end

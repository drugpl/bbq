require 'rails/generators'

module Bbq
  class Railtie < Rails::Railtie
    rake_tasks do
      load Bbq.root.join("lib/tasks/bbq.rake")
    end

    helper_generators = %w(test_unit rspec).collect do |test_framework|
      ["#{test_framework}:bbq_test", "#{test_framework}:bbq_install"]
    end.flatten

    Rails::Generators.hide_namespaces *helper_generators
  end
end

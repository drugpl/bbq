module Bbq
  class Railtie < Rails::Railtie
    rake_tasks do
      load Bbq.root.join("lib/tasks/bbq.rake")
    end
  end
end

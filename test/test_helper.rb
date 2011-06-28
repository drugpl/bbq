# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

if RUBY_VERSION < "1.9"
  gem "minitest"
  `use_minitest yes`
  at_exit { `use_minitest no` }
end

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load database schema
ActiveRecord::Base.configurations = YAML.load(File.read(File.expand_path("../dummy/config/database.yml", __FILE__)))
ActiveRecord::Base.establish_connection("test")
ActiveRecord::Migration.verbose = false
load(File.expand_path("../dummy/db/schema.rb", __FILE__))

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Load database schema
ActiveRecord::Base.configurations = YAML.load(File.read(File.expand_path("../../config/database.yml", __FILE__)))
ActiveRecord::Base.establish_connection("test")
ActiveRecord::Migration.verbose = false
load(File.expand_path("../../db/schema.rb", __FILE__))


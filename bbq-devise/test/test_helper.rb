require 'minitest/autorun'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

ActiveRecord::Base.configurations = YAML.load(File.read(File.expand_path("../dummy/config/database.yml", __FILE__)))
ActiveRecord::Base.establish_connection("test")
ActiveRecord::Migration.verbose = false
load File.expand_path("../dummy/db/schema.rb", __FILE__)

require 'bbq/core'
Bbq::Core.app = Dummy::Application

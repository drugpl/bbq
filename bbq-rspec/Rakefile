require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/unit/*_test.rb' # Don't load test/dummy/test && test/dope/test etc. because we run them from our tests with proper commands setup.
  t.verbose = false
end

task :default => :test

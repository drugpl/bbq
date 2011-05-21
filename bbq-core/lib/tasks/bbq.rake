require 'rake/testtask'

Rake::TestTask.new("test:acceptance") do |t|
  t.libs << 'test'
  t.pattern = 'test/acceptance/*_test.rb'
  t.verbose = false
end


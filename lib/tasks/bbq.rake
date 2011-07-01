require 'rake/testtask'

Rake::TestTask.new("test:acceptance") do |t|
  t.libs << 'test'
  t.pattern = 'test/acceptance/**/*_test.rb'
  t.verbose = false
end if File.exists?('test/acceptance')

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new('spec:acceptance') do |spec|
    spec.pattern = FileList['spec/acceptance/**/*_spec.rb']
  end if File.exists?('spec/acceptance')
rescue LoadError
end

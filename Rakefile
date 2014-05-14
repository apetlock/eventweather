require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Run RSpec tests'
RSpec::Core::RakeTask.new :spec
task test: :spec

desc 'Launch library console'
task :console do
  sh 'irb -I lib -r eventweather'
end

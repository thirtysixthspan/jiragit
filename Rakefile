require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

task :default => :spec


namespace :gem do

  task :build do
    `gem build jiragit.gemspec`
  end

  task :install => [:build] do
    `gem install pkg/jiragit-1.0.0.gem`
  end

end

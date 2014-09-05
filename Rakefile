require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

require_relative 'spec/config/timecop'

reset_time

# used for the preview
require_relative 'lib/tricle'
require_relative 'lib/tricle/tasks'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

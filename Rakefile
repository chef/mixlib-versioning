require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:unit)

begin
  require 'yard'
  YARD::Rake::YardocTask.new(:doc)
rescue LoadError; end

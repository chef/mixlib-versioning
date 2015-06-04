require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:unit)

require 'rubocop/rake_task'
desc 'Run Ruby style checks'
RuboCop::RakeTask.new(:style)

require 'yard'
YARD::Rake::YardocTask.new(:doc)

namespace :travis do
  desc 'Run tests on Travis'
  task ci: [:style, :unit]
end

task default: [:style, :unit]

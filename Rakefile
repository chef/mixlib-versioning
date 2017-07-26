require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:unit)

begin
  require "chefstyle"
  require "rubocop/rake_task"
  RuboCop::RakeTask.new(:chefstyle) do |task|
    task.options << "--display-cop-names"
  end
rescue LoadError
  puts "chefstyle gem is not installed"
end

require "yard"
YARD::Rake::YardocTask.new(:doc)

namespace :travis do
  desc "Run tests on Travis CI"
  task ci: %w{chefstyle unit}
end

task default: %w{travis:ci}

require "bundler/gem_tasks"

require "rspec/core/rake_task"
require "mixlib/versioning/version"

RSpec::Core::RakeTask.new(:unit)

begin
  require "chefstyle"
  require "rubocop/rake_task"
  RuboCop::RakeTask.new(:style) do |task|
    task.options << "--display-cop-names"
  end
rescue LoadError
  puts "chefstyle gem is not installed"
end

require "yard"
YARD::Rake::YardocTask.new(:doc)

# ChefStyle requires Ruby version 2.x and later, and we skip the gem install/load for 1.9.x
task_list = [:unit]
task_list.insert(:style) if RUBY_VERSION =~ /^2/

namespace :travis do
  desc "Run tests on Travis"
  task ci: task_list
end

task default: task_list

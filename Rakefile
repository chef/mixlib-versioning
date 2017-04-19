require "bundler/gem_tasks"

require "rspec/core/rake_task"
require "mixlib/versioning/version"

RSpec::Core::RakeTask.new(:unit)

require "chefstyle"
require "rubocop/rake_task"
desc "Run Ruby style checks"
RuboCop::RakeTask.new(:style)

require "yard"
YARD::Rake::YardocTask.new(:doc)

begin
  require "github_changelog_generator/task"

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.issues = false
    config.future_release = Mixlib::Versioning::VERSION
  end
rescue LoadError
  puts "github_changelog_generator is not available. gem install github_changelog_generator to generate changelogs"
end

namespace :travis do
  desc "Run tests on Travis"
  task ci: [:style, :unit]
end

task default: [:style, :unit]

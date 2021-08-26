source "https://rubygems.org"

gemspec

group :docs do
  gem "yard"
  gem "redcarpet"
  gem "github-markup"
end

group :test do
  gem "chefstyle", "=0.4.0" # pin needed until we drop Ruby 2.0/2.1 support
  gem "rspec", "~> 3.0"
  gem "rspec-its"
  gem "rake"
end

group :development do
  gem "pry"
  gem "pry-byebug"
  gem "pry-stack_explorer", "=0.4.12" # pin until we drop ruby < 2.6
  gem "rb-readline"
end

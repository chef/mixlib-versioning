source "https://rubygems.org"

gemspec

group :docs do
  gem "yard"
  gem "redcarpet"
  gem "github-markup"
end

group :test, :development do
  gem "rspec", "~> 3.0"
  gem "rspec-its"
  gem "rake", "~> 12"
end

if RUBY_VERSION =~ /^2/
  group :chefstyle do
    gem "chefstyle"
  end
end

instance_eval(ENV["GEMFILE_MOD"]) if ENV["GEMFILE_MOD"]

# If you want to load debugging tools into the bundle exec sandbox,
# add these additional dependencies into Gemfile.local
eval(IO.read(__FILE__ + ".local"), binding) if File.exist?(__FILE__ + ".local")

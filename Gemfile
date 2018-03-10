source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'inky-rb', require: 'inky'
gem 'jbuilder',     '~> 2.5'
gem 'jquery-rails'
gem 'material_icons'
gem 'materialize-sass'
gem 'pg',           '~> 0.18'
gem 'premailer-rails'
gem 'puma',         '~> 3.0'
gem 'rails',        '~> 5.0.1'
gem 'redis'
gem 'sass-rails',   '~> 5.0'
gem 'sidekiq'
gem 'turbolinks',   '~> 5'
gem 'uglifier',     '>= 1.3.0'

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console',           '>= 3.3.0'
end

group :test do
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rspec-sidekiq'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
end

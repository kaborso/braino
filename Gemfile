source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'sinatra'
gem 'grape'
gem 'puma'
gem 'aws-sdk', '2.8.9'
gem "mini_magick"
group :test do
  gem 'airborne'
  gem 'rspec'
  gem 'simplecov', require: false
end
group :development do
  gem 'guard-rspec', require: false
end

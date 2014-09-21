source 'https://rubygems.org'

gemspec

gem "rspec-mocks", "~> 3.0"
gem "yard", "~> 0.8"
gem "pry"

case ENV["RAILS"]
when "3.2"
  version = "~> 3.2.19"
  gem "actionpack", version
  gem "railties", version
  gem "tzinfo", "~> 0.3.29"
  gem "minitest", "~> 4.2"
when "4.0"
  version = '~> 4.0.0'
  gem 'actionpack', version
  gem 'railties', version
  gem "minitest", "~> 4.2"
when nil, "4.1"
  version = '~> 4.1.0'
  gem 'actionpack', version
  gem 'railties', version
  gem "minitest", "~> 5.4"
end

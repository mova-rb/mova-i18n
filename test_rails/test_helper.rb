# Rails setup is heavily based on https://github.com/semaperepelitsa/subdomain_locale

ENV["RAILS_ENV"] = "test"

require "bundler/setup"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "minitest/autorun"
require "rails/test_help"
Rails.backtrace_cleaner.remove_silencers!

$VERBOSE = true

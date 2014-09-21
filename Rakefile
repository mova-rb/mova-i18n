require "bundler/gem_tasks"

rails_versions = %w(3.2 4.0 4.1)

task :default => :test

task :bundle do
  rails_versions.each do |version|
    sh "RAILS=#{version} bundle"
  end
end

task "test:i18n" do
  $LOAD_PATH.unshift("test")
  Dir.glob("./test/**/*_test.rb").each { |file| require file}
end

task "test:rails" do
  Dir.glob("./test_rails/**/*_test.rb").each { |file| require file}
end

task :test => "test:i18n" do
  sh "rake test:rails"
end

task "test:all" => "test:i18n" do
  rails_versions.each do |version|
    sh "RAILS=#{version} rake test:rails"
  end
end

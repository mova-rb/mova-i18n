require "bundler/gem_tasks"

rails_versions = %w(3.2 4.0 4.1)

task :default => :test

task :bundle do
  rails_versions.each do |version|
    sh "RAILS=#{version} bundle"
  end
end

task :test do
  $LOAD_PATH.unshift("test")
  Dir.glob("./test/**/*_test.rb").each { |file| require file}

  rails_versions.each do |version|
    sh "RAILS=#{version} rake test:rails"
  end
end

task "test:rails" do
  Dir.glob("./test_rails/**/*_test.rb").each { |file| require file}
end

desc "Runs chefspec against the cookbook."
task :chefspec do
  sh "bundle exec rspec"
end

desc "Runs foodcritic against the cookbook."
task :foodcritic do
  sh "bundle exec foodcritic -f any ."
end

desc "Runs tailor against the cookbook."
task :tailor do
  sh "bundle exec tailor"
end

desc "Runs all tests against the cookbook."
task :build do
  Rake::Task[:tailor].execute
  Rake::Task[:foodcritic].execute
  Rake::Task[:chefspec].execute
end

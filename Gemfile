source 'https://rubygems.org'

gem 'berkshelf'
gem 'thor-foodcritic'

group :test do
  gem "rake"
  gem "tailor"
  gem "chefspec"
  gem "foodcritic"
end

group :integration do
  gem "test-kitchen", git: 'git://github.com/opscode/test-kitchen.git'
  gem 'kitchen-vagrant', git: 'git://github.com/opscode/kitchen-vagrant.git', branch: 'master'
  gem "guard"
  gem "guard-rspec"
  gem "guard-kitchen"
  gem "ruby_gntp"
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end
source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :test do
  if RUBY_VERSION.start_with? '1.8'
    gem 'rake', '< 11',           :require => false
  else
    gem 'rake', '< 12',           :require => false
  end
  gem 'rspec', '~>3.1.0',         :require => false
  gem 'rspec-puppet', '~>2.x',    :require => false
  gem 'rspec-puppet-facts', '>= 1.7.0',      :require => false
  gem 'puppetlabs_spec_helper',   :require => false
  gem 'puppet-lint',              :require => false
  gem 'puppet-syntax',            :require => false
  gem 'simplecov',                :require => false
  gem 'ruby-puppetdb', '~>1.0',   :require => false
  gem 'deep_merge'
  gem 'parallel_tests',           :require => false
end

group :system_tests do
  gem 'beaker',                   :require => false
  gem 'beaker-rspec',             :require => false
  gem 'serverspec',               :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', '~>5.0', :require => false
end

# vim:ft=ruby

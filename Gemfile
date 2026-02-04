source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :development do
  gem "json", '= 2.1.0',                         require: false if Gem::Requirement.create(['>= 2.5.0', '< 2.7.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "json", '= 2.3.0',                         require: false if Gem::Requirement.create(['>= 2.7.0', '< 3.0.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "json", '= 2.5.1',                         require: false if Gem::Requirement.create(['>= 3.0.0', '< 3.0.5']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "json", '= 2.6.1',                         require: false if Gem::Requirement.create(['>= 3.1.0', '< 3.1.3']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "json", '= 2.6.3',                         require: false if Gem::Requirement.create(['>= 3.2.0', '< 4.0.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "voxpupuli-puppet-lint-plugins", '~> 5.0', require: false
  gem "facterdb", '~> 2.1',                      require: false
  gem "metadata-json-lint", '~> 4.0',            require: false
  gem "rspec-puppet-facts", '~> 4.0',            require: false
  gem "dependency_checker", '~> 1.0.0',          require: false
  # gem "simplecov-console", '~> 0.9',           require: false  # Commented out due to platform compatibility
  gem "puppet-debugger", '~> 1.0',               require: false
  gem "rubocop", '~> 1.50.0',                    require: false
end
group :development, :release_prep do
  gem "puppet-strings", '~> 4.0',         require: false
  gem "puppetlabs_spec_helper", '~> 8.0', require: false
end

puppet_version = ENV['PUPPET_GEM_VERSION']
gem 'puppet', puppet_version || '>= 7.0', require: false
gem 'facter', ENV['FACTER_GEM_VERSION'] || '>= 4.0', require: false

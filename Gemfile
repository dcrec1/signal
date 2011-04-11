source :gemcutter

gem 'rails', '3.0.6'
gem 'sqlite3-ruby'
gem 'mysql', :group => :production
gem 'haml'
gem 'inherited_resources', '>=1.1.2'
gem 'git'
gem 'formtastic', '>=1.1.0'
gem 'hoptoad_notifier'
gem 'more', '0.0.3'
gem 'friendly_id', '>=3.1.8'
gem 'delayed_job', '>=2.1'
gem "compass", ">= 0.10.2"
gem "daemons"

gem 'inploy', '>=1.9'

gem 'metric_fu'

group :development, :test do
  gem 'rspec', '>=2.0.1'
  gem 'rspec-rails', '>=2.0.1'
  gem "factory_girl_rails"
  platforms :mri_18 do
    gem "ruby-debug"
  end

  platforms :mri_19 do
    gem "ruby-debug19"
  end  
end

group :test do
  gem "remarkable", ">=4.0.0.alpha4"
  gem "remarkable_activemodel", ">=4.0.0.alpha4"
  gem "remarkable_activerecord", ">=4.0.0.alpha4"
  gem "webrat"
  gem 'faker'
end

group :cucumber do
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'capybara'
  gem "launchy"
  gem 'spork', ">=0.8.4"
  gem "pickle", ">=0.4.2"
end

group :production do
  gem "mysql2"
end

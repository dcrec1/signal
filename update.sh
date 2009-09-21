git pull origin master
rake gems:install
rake db:migrate RAILS_ENV=production
rake asset:packager:build_all

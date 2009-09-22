cp config/mailer.yml.sample config/mailer.yml
cp config/database.yml.sample config/database.yml
rake gems:install
mkdir -p tmp/pids

application = "signal"
repository = 'git://github.com/dcrec1/signal.git'
user = 'dcrec1'
hosts = ['hooters', 'geni']
path = '/opt'

before_restarting_server do
  run "script/delayed_job -e production restart"
end

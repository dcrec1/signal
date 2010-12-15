application = "signal"
repository = 'git://github.com/dcrec1/signal.git'
hosts = []

before_restarting_server do
  run "script/delayed_job -e production restart"
end

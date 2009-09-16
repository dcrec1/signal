Dir[File.join(File.dirname(__FILE__), 'action_controller', '*.rb')].each do |file|
  require file
end

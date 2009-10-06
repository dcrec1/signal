require File.expand_path(File.dirname(__FILE__) + '/../inploy')

def deploy
  @deploy ||= Inploy::Deploy.new
end

require "config/deploy.rb"

namespace :inploy do
  namespace :local do
    desc "Local Setup"
    task :setup do
      deploy.local_setup
    end

    desc "Local Update"
    task :update do
      deploy.local_update
    end
  end

  namespace :remote do
    desc "Remote Setup"
    task :setup do
      deploy.remote_setup
    end

    desc "Remote Update"
    task :update do
      deploy.remote_update
    end
  end
end
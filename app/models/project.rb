class Project < ActiveRecord::Base
  BASE_PATH = "#{RAILS_ROOT}/public/projects"
  BUILDING = "building"

  has_friendly_id :name
  before_update :rename_directory

  validates_presence_of :name, :url, :email

  has_many :builds
  has_many :deploys

  def after_create
    execute "cd #{BASE_PATH} && git clone --depth 1 #{url} #{name}"
    run "git checkout -b #{branch} origin/#{branch} >" unless branch.eql? "master"
    run "rvm gemset create #{name} >>"
    run "rake inploy:local:setup >>"
  end

  def status
    building ? BUILDING : builds.last.try(:status)
  end

  def build
    update_attribute :building, true
    builds.create
    update_attribute :building, false
  end

  def deploy
    deploys.create
  end

  def last_builded_at
    builds.last.try(:created_at)
  end

  def has_file?(file)
    File.exists?("#{path}/#{file}")  
  end

  def activity
    building? ? 'Building' : 'Sleeping'
  end

  protected

  def rename_directory
    execute "cd #{BASE_PATH} && mv #{name_was} #{name}" if self.name_changed?
  end

  def update_code
    run "git pull #{url} #{branch} >"
  end

  def last_commit
    Git.open(path).log.first
  end

  def run_build_command
    run "rvm gemset use #{name} >>"
    result = run "#{build_command} -N RAILS_ENV=test >>"
    return result, File.open(log_path).read
  end

  def run_deploy
    return run("#{self.deploy_command} >"), File.open(log_path).read
  end

  private

  def path
    "#{BASE_PATH}/#{name}"
  end

  def log_path
    "#{RAILS_ROOT}/tmp/#{name}"
  end

  def run(cmd)
    execute "cd #{path} && #{cmd} #{log_path} 2>&1"
  end

  def execute(command)
    Rails.logger.info "Signal => #{command}"
    Kernel.system command
  end
end

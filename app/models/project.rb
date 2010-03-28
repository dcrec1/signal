class Project < ActiveRecord::Base
  BASE_PATH = "#{RAILS_ROOT}/public/projects"

  has_friendly_id :name
  before_update :rename_directory

  validates_presence_of :name, :url, :email

  has_many :builds
  has_many :deploys

  default_value_for :branch, "master"

  def after_create
    execute "cd #{BASE_PATH} && git clone --depth 1 #{url} #{name}"
    run "git checkout -b #{branch} origin/#{branch} >" unless branch.eql? "master"
    run "rake inploy:local:setup >>"
  end

  def status
    builds.last.try(:status)
  end

  def build
    builds.create
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

  protected

  def rename_directory
    execute "cd #{BASE_PATH} && mv #{name_was} #{name}" if self.name_changed?
  end

  def update_code
    run "git pull origin #{branch} >"
  end

  def last_commit
    Git.open(path).log.first
  end

  def rake_build
    rake "build -N RAILS_ENV=test >>"
  end

  def run_deploy
    return run("#{self.deploy_command} >"), File.open(log_path).read
  end

  private

  def rake(cmd)
    result = run "rake #{cmd}"
    return result, File.open(log_path).read
  end

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

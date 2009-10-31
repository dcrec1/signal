class Project < ActiveRecord::Base
  BASE_PATH = "#{RAILS_ROOT}/public/projects"

  has_friendly_id :name
  before_update :rename_directory

  validates_presence_of :name, :url, :email

  has_many :builds
  has_many :deploys

  def after_create
    execute "cd #{BASE_PATH} && git clone #{url} #{name}"
    run "rake inploy:local:setup >"
  end
  
  def status
    builds.last.try(:status) || ''
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

  protected
  
  def rename_directory
    execute "cd #{BASE_PATH} && mv #{name_was} #{name}" if self.name_changed?
  end

  def update_code
    run "git pull origin master >"
  end
  
  def last_commit
    Git.open(path).log.first
  end

  def rake_build
    rake "build -N RAILS_ENV=test >>"
  end

  def rake_deploy
    rake "inploy:remote:update >"
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

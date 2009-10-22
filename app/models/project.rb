class Project < ActiveRecord::Base
  BASE_PATH = "#{RAILS_ROOT}/public/projects"

  has_friendly_id :name

  validates_presence_of :name, :url, :email
  has_many :builds

  def after_create
    execute "cd #{BASE_PATH} && git clone #{url} #{name}"
  end

  def path
    "#{BASE_PATH}/#{name}"
  end

  def log_path
    "#{RAILS_ROOT}/tmp/#{name}"
  end

  def status
    builds.last.try(:status) || ''
  end

  def build
    builds.create
  end

  def last_builded_at
    builds.last.try(:created_at)
  end

  def last_commit
    Git.open(path).log.first
  end

  def update
    run "git pull origin master > #{log_path} 2>&1"
  end

  protected

  def rake_build
    run "rake build -N RAILS_ENV=test >> #{log_path} 2>&1"
  end

  private

  def run(cmd)
    execute "cd #{path} && #{cmd}"
  end

  def execute(command)
    Kernel.system command
  end
end

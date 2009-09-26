class Project < ActiveRecord::Base
  BASE_PATH = "#{RAILS_ROOT}/public/projects"

  has_friendly_id :name

  validates_presence_of :name, :url, :email
  has_many :builds

  def after_create
    Kernel.system "cd #{BASE_PATH} && git clone #{url} #{name}"
  end

  def path
    "#{BASE_PATH}/#{name}"
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
    Grit::Repo.new(path).commits.last
  end
  
  def run(cmd)
    Kernel.system "cd #{path} && #{cmd}"
  end
end

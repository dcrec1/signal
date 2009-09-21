class Project < ActiveRecord::Base
  BASE_PATH = "#{RAILS_ROOT}/public/projects"

  validates_presence_of :name, :url, :email
  has_many :builds

  def after_create
    Kernel.system "cd #{BASE_PATH} && git clone #{url} #{name}"
  end

  def path
    "#{BASE_PATH}/#{name}"
  end

  def status
    return '' if builds.empty?
    builds.last.status
  end

  def build
    builds.create
  end
end

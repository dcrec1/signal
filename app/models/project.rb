class Project < ActiveRecord::Base
  BASE_PATH = "#{RAILS_ROOT}/public/projects"
  SUCCESS   = "success"
  FAIL      = "failure"

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
    builds.last.successful ? SUCCESS : FAIL
  end
end

class Project < ActiveRecord::Base
  BASE_PATH = "#{RAILS_ROOT}/public/projects"

  validates_presence_of :name, :url, :email

  def after_create
    Kernel.system "cd #{BASE_PATH} && git clone #{url} #{name}"
  end
end

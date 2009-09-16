class Build < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project, :log, :success

  def before_validation_on_create
    unless project.nil?
      Kernel.system "cd #{project.path} && git fetch origin master > tmp/log"
      Kernel.system "cd #{@project.path} && rake build >> tmp/log"
      self.log = File.open("#{project.path}/tmp/log").read
      self.success = true
    end
  end
end

class Build < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project, :log

  def before_validation_on_create
    unless project.nil?
      Kernel.system "cd #{project.path} && git fetch origin master > #{log_path}"
      self.successful = Kernel.system "cd #{@project.path} && rake build >> #{log_path}"
      self.log = File.open(log_path).read
    end
  end

  private

  def log_path
    "#{RAILS_ROOT}/tmp/#{project.name}"
  end
end

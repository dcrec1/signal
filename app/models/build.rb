class Build < ActiveRecord::Base
  delegate :last_commit, :to => :project
  
  SUCCESS   = "success"
  FAIL      = "failure"

  belongs_to :project
  validates_presence_of :project, :output, :commit, :author, :comment

  def status
    success ? SUCCESS : FAIL
  end

  protected

  def before_validation_on_create
    return nil if project.nil?
    self.output = build
    take_data_from last_commit
  end

  def after_validation_on_create
    Notifier.deliver_fix_notification self if fix?
  end

  def after_create
    Notifier.deliver_fail_notification self unless success
  end

  private

  def take_data_from(commit)
    self.commit = commit.sha
    self.author = commit.author.name
    self.comment = commit.message
  end

  def fix?
    success and Build.last.try(:success) == false
  end

  def build
    update_project
    run_specs
    return log_content
  end

  def log_path
    "#{RAILS_ROOT}/tmp/#{project.name}"
  end

  def log_content
    File.open(log_path).read
  end

  def run_specs
    self.success = run "rake build RAILS_ENV=test >> #{log_path}"
  end

  def update_project
    run "git pull origin master > #{log_path}"
  end
  
  def run(cmd)
    project.run cmd
  end 
end
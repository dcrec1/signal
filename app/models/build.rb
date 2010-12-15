class Build < ActiveRecord::Base
  include Status

  belongs_to :project
  validates_presence_of :project, :output, :commit, :author, :comment

  protected

  before_validation :on => :create do
    return nil if project.nil?
    project.update_code
    self.success, self.output = project.run_build_command
    take_data_from project.last_commit
  end

  after_validation :on => :create do
    Notifier.fix_notification(self).deliver if fix?
  end

  after_create do
    Notifier.fail_notification(self).deliver unless success
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
end

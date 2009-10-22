class Build < ActiveRecord::Base
  include Status

  belongs_to :project
  validates_presence_of :project, :output, :commit, :author, :comment

  protected

  def before_validation_on_create
    return nil if project.nil?
    project.update
    self.success, self.output = project.rake_build
    take_data_from project.last_commit
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
end

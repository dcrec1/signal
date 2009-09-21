class Build < ActiveRecord::Base
  SUCCESS   = "success"
  FAIL      = "failure"

  belongs_to :project
  validates_presence_of :project, :output, :commit, :author, :comment

  def before_validation_on_create
    unless project.nil?
      self.success, self.output = build project
      commit = Grit::Repo.new(project.path).commits.first
      self.commit = commit.id
      self.author = commit.author.name
      self.comment = commit.message
    end
  end

  def after_validation_on_create
    Notifier.deliver_fix_notification self if fixed(Build.last)
  end

  def after_create
    Notifier.deliver_fail_notification self if build_failed
  end

  def status
    success ? SUCCESS : FAIL
  end

  private

  def build_failed
    !self.success
  end

  def fixed(build)
    self.success and !build.nil? and !build.success
  end

  def build(project)
    update_project
    return result_for_specs, log_content
  end

  def run(cmd, opts)
    Kernel.system "cd #{opts[:for].path} && #{cmd}"
  end

  def log_path
    "#{RAILS_ROOT}/tmp/#{project.name}"
  end

  def log_content
    File.open(log_path).read
  end

  def result_for_specs
    run "rake build RAILS_ENV=test >> #{log_path}", :for => project
  end

  def update_project
    run "git pull origin master > #{log_path}", :for => project
  end
end

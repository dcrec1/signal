class Build < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project, :log

  def before_validation_on_create
    self.successful, self.log = build project unless project.nil?
  end

  private

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
    run "git fetch origin master > #{log_path}", :for => project
  end
end

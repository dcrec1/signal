class Notifier < ActionMailer::Base

  def fail_notification(build)
    project = build.project
    from "signal@#{MAILER['domain']}"
    recipients project.email
    subject "[Signal] #{project.name} failed"
    body :build => build, :project => project
  end

  def fix_notification(build)
  end
end

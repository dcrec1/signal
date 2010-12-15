require 'spec/mocks'

class Project
  def execute(param)
  end

  def last_commit
    Git.open(Rails.root).log.first
  end
end

Before do
  system "echo \"123456789\" > tmp/whatever"
end

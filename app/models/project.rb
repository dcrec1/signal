class Project < ActiveRecord::Base
  BASE_PATH = "#{RAILS_ROOT}/public/projects"

  has_friendly_id :name

  validates_presence_of :name, :url, :email
  has_many :builds

  def after_create
    execute "cd #{BASE_PATH} && git clone #{url} #{name}"
  end

  def path
    "#{BASE_PATH}/#{name}"
  end

  def status
    builds.last.try(:status) || ''
  end

  def build
    builds.create
    clean_cache
  end

  def last_builded_at
    builds.last.try(:created_at)
  end

  def last_commit
    Git.open(path).log.first
  end

  def run(cmd)
    execute "cd #{path} && #{cmd}"
  end

  private

  def delete(*names)
    names.each do |name|
      begin
        File.delete "public/cache/#{name}.html"
      rescue Exception
      end
    end
  end

  def clean_cache
    delete "index", "projects", "projects/status", "projects/#{self.name}"
  end

  def execute(command)
    Kernel.system command
  end
end

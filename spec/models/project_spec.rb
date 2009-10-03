require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  should_validate_presence_of :name, :url, :email
  should_have_many :builds

  it "should have public/projects as the projects base path" do
    Project::BASE_PATH.should eql("#{RAILS_ROOT}/public/projects")
  end

  it "should return the path of the project" do
    name = "yellow"
    Project.new(:name => name).path.should eql("#{Project::BASE_PATH}/#{name}")
  end

  it "should clone a repository after a project is created" do
    project = Project.new :name => "social", :url => "git://social", :email => "fake@mouseoverstudio.com"
    expect_for "cd #{Project::BASE_PATH} && git clone #{project.url} #{project.name}"
    project.save
  end

  it "responding to build creates a new project" do
    project = Project.new
    project.builds.should_receive(:create)
    project.build
  end

  context "when returing the status" do
    before :each do
      @project = Project.new :builds => [@build = Build.new]
    end

    it "should return #{Build::SUCCESS} when the last build was successful" do
      @build.success = true
      @project.status.should eql(Build::SUCCESS)
    end

    it "should return #{Build::FAIL} when the last build was not successful" do
      @build.success = false
      @project.status.should eql(Build::FAIL)
    end

    it "should return an empty string when there are no builds" do
      @project.builds = []
      @project.status.should be_empty
    end
  end

  it "should return when was the last build" do
    date = Time.now
    Project.new(:builds => [Build.new :created_at => date]).last_builded_at.should eql(date)
  end

  it "should return nil as last build date when no builds exists" do
    Project.new.last_builded_at.should be_nil
  end

  it "should have name as a friendly_id" do
    name = "rails"
    Project.new(:name => name).friendly_id.should eql(name)
  end
end

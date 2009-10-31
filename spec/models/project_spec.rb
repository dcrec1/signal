require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  should_validate_presence_of :name, :url, :email
  should_have_many :builds
  should_have_many :deploys

  it "should have public/projects as the projects base path" do
    Project::BASE_PATH.should eql("#{RAILS_ROOT}/public/projects")
  end

  context "on creation" do
    before :each do
      success_on_command
      @project = Project.new :name => "social", :url => "git://social", :email => "fake@mouseoverstudio.com"
    end

    it "should clone a repository" do
      expect_for "cd #{Project::BASE_PATH} && git clone #{@project.url} #{@project.name}"
      @project.save
    end

    it "should run inploy:local:setup" do
      expect_for "cd #{@project.send :path} && rake inploy:local:setup > #{@project.send :log_path} 2>&1"
      @project.save
    end
  end

  it "should build the project creating a new build" do
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

  it "should rename the directory" do
    project = Project.new(:name => "project1",:url => "git://social", :email => "fake@mouseoverstudio.com")
    project.save
    expect_for "cd #{Project::BASE_PATH} && mv project1 project2"
    project.update_attributes(:name => "project2") 
  end

  it "should return nil as last build date when no builds exists" do
    Project.new.last_builded_at.should be_nil
  end

  it "should have name as a friendly_id" do
    name = "rails"
    Project.new(:name => name).friendly_id.should eql(name)
  end

  it "should deploy the project creating a new deploy" do
    project = Project.new
    project.deploys.should_receive(:create)
    project.deploy
  end
end

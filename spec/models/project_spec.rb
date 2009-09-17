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
    Kernel.should_receive(:system).with("cd #{Project::BASE_PATH} && git clone #{project.url} #{project.name}")
    project.save
  end

  context "when returing the status" do
    before :each do
      @project = Project.new :builds => [@build = Build.new]
    end

    it "should return #{Project::SUCCESS} when the last build was successful" do
      @build.stub!(:successful).and_return(true)
      @project.status.should eql(Project::SUCCESS)
    end

    it "should return #{Project::FAIL} when the last build was not successful" do
      @build.stub!(:successful).and_return(false)
      @project.status.should eql(Project::FAIL)
    end

    it "should return an empty string when there are no builds" do
      @project.builds = []
      @project.status.should be_empty
    end
  end
end

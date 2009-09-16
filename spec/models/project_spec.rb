require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  should_validate_presence_of :name, :url, :email

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
end

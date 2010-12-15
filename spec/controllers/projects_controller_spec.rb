require 'spec_helper'

describe ProjectsController do
  context "responding to build" do
    it "should build a project in the background" do
      Project.stub!(:find).with(project_id = "10").and_return(project = mock(Project))
      project.should_receive(:send_later).with(:build)
      get :build, :project_id => project_id
    end
  end

  context "responding to status" do
    before :each do
      Project.stub!(:all).and_return(@projects = [Project.new])
    end

    it "with html format should render projects template" do
      get :fetch_status
      response.should render_template("shared/_projects")
    end

    it "with xml format should render status.xml" do
      get :fetch_status, :format => 'xml'
      response.should render_template("projects/status")
    end

    it "should assign all the projects to @projects" do
      get :fetch_status
      assigns[:projects].should eql(@projects)
    end
  end
end

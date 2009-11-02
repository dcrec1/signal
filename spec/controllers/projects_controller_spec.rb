require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do
  should_behave_like_resource :formats => [:html, :xml]

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

    it "should return the status html panel for all the projects" do
      get :status
      response.should render_template("shared/_projects")
    end

    it "should assign all the projects to @projects" do
      get :status
      assigns[:projects].should eql(@projects)
    end
  end
end

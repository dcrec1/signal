require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do
  should_behave_like_resource

  context "responding to build" do
    it "should build a project in the background" do
      Project.stub!(:find).with(project_id = "10").and_return(project = mock(Project))
      project.should_receive(:send_later).with(:build)
      get :build, :project_id => project_id
    end
  end
end

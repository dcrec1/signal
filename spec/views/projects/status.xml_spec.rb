require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects/status.xml.haml" do
  context "rendering a xml document respecting CCMMenu specifications" do
    before :each do
      @build = Build.new :success => rand(1)
      @project = Factory.build :project, :builds => [@build]
      assigns[:projects] = @projects = [Factory.build(:project), @project]
    end

    it "creates a Projects > Project node for each project" do
      render
      rendered.should have_selector("projects > project", :count => @projects.size)
    end

    it "sets Project statusselector Unknow if the project hasn't any builds" do
      render
      rendered.should have_selector("project[lastbuildstatus=\"Unknown\"]")
    end

    it "sets Project statusselector the last build status" do
      status = @build.success ? "Success" : "Failure"
      render
      rendered.should have_selector("project[lastbuildstatus=\"#{status}\"]")
    end

    it "sets corresponding selector attributes for the Project node" do
      render
      rendered.should have_selector("project[name=\"#{@project.name}\"]")
      rendered.should have_selector("project[activity=\"Sleeping\"]")
      rendered.should have_selector("project[lastbuildtime=\"#{@build.created_at}\"]")
      rendered.should have_selector("project[weburl=\"#{project_path(@project)}\"]")
    end
  end
end

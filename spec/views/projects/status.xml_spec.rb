require 'spec_helper'

describe "/projects/status.xml.haml" do
  context "rendering a xml document respecting CCMMenu specifications" do
    before :each do
      @build = Build.new :success => rand(1)
      @project = Project.koujou_build :builds => [@build]
      assigns[:projects] = @projects = [Project.koujou_build, @project]
    end
    
    it "creates a Projects > Project node for each project" do
      render
      response.should have_tag("Projects > Project", :count => @projects.size)
    end
    
    it "sets Project status to Unknow if the project hasn't any builds" do
      render
      response.should have_tag("Project[lastBuildStatus=Unknown]")
    end
    
    it "sets Project status to the last build status" do
      status = @build.success ? "Success" : "Failure"
      render
      response.should have_tag("Project[lastBuildStatus=#{status}]")
    end
    
    it "sets corresponding attributes for the Project node" do
      render
      response.should have_tag("Project[name=#{@project.name}]")
      response.should have_tag("Project[activity=Sleeping]")
      response.should have_tag("Project[lastBuildTime=#{@build.created_at}]")
      response.should have_tag("Project[webUrl=#{project_path(@project)}]")
    end
  end
end
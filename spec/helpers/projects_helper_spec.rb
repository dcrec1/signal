require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsHelper do
  include ProjectsHelper
  it "should return the path to project metrics" do
    name = "gogo"
    metrics_path(Project.new :name => name).should eql("/projects/#{name}/tmp/metric_fu/output/index.html")
  end
end

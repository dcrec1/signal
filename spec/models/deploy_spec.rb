require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Deploy do
  should_belong_to :project
  should_validate_presence_of :project, :output

  context "on creation" do
    before :each do
      fail_on_command
      File.stub!(:open).and_return(mock(Object, :read => "lorem ipsum"))
    end

    it "should deploy the project raking inploy:remote:update" do
      project = Project.new :name => "inploy"
      expect_for "cd #{project.send :path} && rake inploy:remote:update > #{project.send :log_path} 2>&1"
      Deploy.create! :project => project
    end
  end
end

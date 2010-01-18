require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Deploy do
  should_belong_to :project
  should_validate_presence_of :project, :output
  it_should_behave_like 'statusable'

  context "on creation" do
    before :each do
      fail_on_command
      File.stub!(:open).and_return(mock(Object, :read => "lorem ipsum"))
      @project = Project.new :name => "inploy"
    end

    it "should deploy the project raking inploy:remote:update" do
      expect_for "cd #{@project.send :path} && #{@project.deploy_command} > #{@project.send :log_path} 2>&1"
      Deploy.create! :project => @project
    end

    it "should save the log" do
      log = "Can't touch this!"
      File.stub!(:open).with(@project.send :log_path).and_return(mock(Object, :read => log))
      Deploy.create!(:project => @project).output.should eql(log)
    end

    it "should determine if the deploy was a success or not" do
      success_on_command
      Deploy.create!(:project => @project).success.should be_true
    end
  end
end

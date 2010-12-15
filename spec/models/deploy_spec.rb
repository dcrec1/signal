require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Deploy do
  should_belong_to :project
  should_validate_presence_of :project, :output
  it_should_behave_like 'statusable'

  context "on creation" do
    let(:log) { "lorem ipsum 2" }
    let(:project) { Factory :project, :name => "inploy" }

    before :each do
      fail_on_command
      system "echo \"#{log}\" > tmp/#{project.name}"
    end

    it "should deploy the project executing the project deploy command" do
      expect_for "cd #{project.send :path} && #{project.deploy_command} > #{project.send :log_path} 2>&1"
      Deploy.create! :project => project
    end

    it "should save the log" do
      Deploy.create!(:project => project).output.should include(log)
    end

    it "should determine if the deploy was a success or not" do
      success_on_command
      Deploy.create!(:project => project).success.should be_true
    end
  end
end

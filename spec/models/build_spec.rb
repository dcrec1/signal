require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Build do
  should_belong_to :project
  should_validate_presence_of :project, :log

  context "on creation" do
    before :each do
      Kernel.stub!(:system).and_return(false)
      File.stub!(:open).and_return(mock(Object, :read => "lorem ipsum"))
      @project = Project.koujou
      @log_path = "#{RAILS_ROOT}/tmp/#{@project.name}"
    end

    it "should fetch the repository" do
      Kernel.should_receive(:system).with("cd #{@project.path} && git fetch origin master > #{@log_path}")
      Build.create! :project => @project
    end

    it "should build the project" do
      Kernel.should_receive(:system).with("cd #{@project.path} && rake build >> #{@log_path}")
      Build.create! :project => @project
    end

    it "should save the log" do
      log = "Can't touch this!"
      File.stub!(:open).with(@log_path).and_return(mock(Object, :read => log))
      Build.create!(:project => @project).log.should eql(log)
    end

    it "should determine if the build was a success or not" do
      Kernel.stub!(:system).and_return(false)
      Build.create!(:project => @project).successful.should be_false
    end
  end
end

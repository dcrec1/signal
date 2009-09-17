require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Build do
  should_belong_to :project
  should_validate_presence_of :project, :output

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

    it "should build the project with the test environment" do
      Kernel.should_receive(:system).with("cd #{@project.path} && rake build RAILS_ENV=test >> #{@log_path}")
      Build.create! :project => @project
    end

    it "should save the log" do
      log = "Can't touch this!"
      File.stub!(:open).with(@log_path).and_return(mock(Object, :read => log))
      Build.create!(:project => @project).output.should eql(log)
    end

    it "should determine if the build was a success or not" do
      Kernel.stub!(:system).and_return(false)
      Build.create!(:project => @project).success.should be_false
    end

    it "should not deliver an email when build don't fail" do
      Kernel.stub!(:system).and_return(true)
      build = Build.new :project => @project
      Notifier.should_not_receive(:deliver_fail_notification).with(build)
      build.save
    end

    it "should deliver an emails if build fails" do
      Kernel.stub!(:system).and_return(false)
      build = Build.new :project => @project
      Notifier.should_receive(:deliver_fail_notification).with(build)
      build.save
    end
  end
end

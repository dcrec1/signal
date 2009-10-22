require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Build do
  should_belong_to :project
  should_validate_presence_of :project, :output, :commit, :author, :comment

  context "on creation" do
    before :each do
      fail_on_command
      File.stub!(:open).and_return(mock(Object, :read => "lorem ipsum"))
      @project = Project.koujou
      build_repo_for @project
      @log_path = "#{RAILS_ROOT}/tmp/#{@project.name}"
    end

    it "should pull the repository" do
      expect_for "cd #{@project.send :path} && git pull origin master > #{@log_path} 2>&1"
      Build.create! :project => @project
    end

    it "should build the project with the test environment" do
      expect_for "cd #{@project.send :path} && rake build -N RAILS_ENV=test >> #{@log_path} 2>&1"
      Build.create! :project => @project
    end

    it "should save the log" do
      log = "Can't touch this!"
      File.stub!(:open).with(@log_path).and_return(mock(Object, :read => log))
      Build.create!(:project => @project).output.should eql(log)
    end

    it "should determine if the build was a success or not" do
      fail_on_command
      Build.create!(:project => @project).success.should be_false
    end

    it "should not deliver a fail notification email when build don't fail" do
      success_on_command
      build = Build.new :project => @project
      Notifier.should_not_receive(:deliver_fail_notification).with(build)
      build.save
    end

    it "should deliver an fail notification email if build fails" do
      fail_on_command
      build = Build.new :project => @project
      Notifier.should_receive(:deliver_fail_notification).with(build)
      build.save
    end

    it "should deliver a fix notification email if build success and last build failed" do
      success_on_command
      Build.stub!(:last).and_return(mock(Build, :success => false))
      build = Build.new :project => @project
      Notifier.should_receive(:deliver_fix_notification).with(build)
      build.save
    end

    it "should not deliver a fix notification email if build success and last build successed" do
      success_on_command
      Build.stub!(:last).and_return(mock(Build, :success => true))
      build = Build.new :project => @project
      Notifier.should_not_receive(:deliver_fix_notification).with(build)
      build.save
    end

    it "should not deliver a fix notification email if build fail and last build failed" do
      fail_on_command
      Build.stub!(:last).and_return(mock(Build, :success => false))
      build = Build.new :project => @project
      Notifier.should_not_receive(:deliver_fix_notification).with(build)
      build.save
    end

    it "should not deliver a fix notification email if build fail and last build successed" do
      fail_on_command
      Build.stub!(:last).and_return(mock(Build, :success => false))
      build = Build.new :project => @project
      Notifier.should_not_receive(:deliver_fix_notification).with(build)
      build.save
    end

    it "should save the author of the commit that forced the build" do
      Build.create!(:project => @project).author.should eql(@author)
    end

    it "should save the hash of the commit that forced the build" do
      Build.create!(:project => @project).commit.should eql(@commit)
    end

    it "should save the comment of the commit that forced the build" do
      Build.create!(:project => @project).comment.should eql(@comment)
    end
  end
end

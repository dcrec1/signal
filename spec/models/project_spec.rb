require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  should_validate_presence_of :name, :url, :email
  should_have_many :builds
  should_have_many :deploys

  it "should have public/projects as the projects base path" do
    Project::BASE_PATH.should eql("#{Rails.root}/public/projects")
  end

  it "should have default build_command as 'rake build'" do
    subject.build_command.should eql("rake build")
  end

  context "on creation" do
    subject { Factory.build :project }

    before :each do
      success_on_command
    end

    it "should clone a repository without the history" do
      expect_for "cd #{Project::BASE_PATH} && git clone --depth 1 #{subject.url} #{subject.name}"
      subject.save
    end

    it "should checkout the configured branch if different from master" do
      subject.branch = "integration"
      expect_for "cd #{subject.send :path} && git checkout -b #{subject.branch} origin/#{subject.branch} > #{subject.send :log_path} 2>&1"
      subject.save
    end

    it "should dont checkout the configured branch if it's master" do
      subject.branch = "master"
      dont_accept "cd #{subject.send :path} && git checkout -b #{subject.branch} origin/#{subject.branch} > #{subject.send :log_path} 2>&1"
      subject.save
    end

    it "should create a gemset with the subject name" do
      expect_for "cd #{subject.send :path} && rvm gemset create #{subject.name} >> #{subject.send :log_path} 2>&1"
      subject.save
    end

    it "should run inploy:local:setup" do
      expect_for "cd #{subject.send :path} && rake inploy:local:setup >> #{subject.send :log_path} 2>&1"
      subject.save
    end

  end

  context "on #build" do
    subject { Factory.build :project }

    before :each do
      success_on_command
    end

    it "should create a new build" do
      subject.builds.should_receive(:create)
      subject.build_without_delay
    end

    it "should set the project as building while building" do
      subject.builds.should_receive(:create) do
        Project.last.should be_building
      end
      subject.build_without_delay
    end

    it "should set the project as not building after build" do
      subject.builds.stub!(:create)
      subject.build_without_delay
      subject.should_not be_building
    end

    it "should be async" do
      subject.should respond_to(:build_with_delay)
    end
  end

  context "on #activity" do
    it "should return Sleeping when not being build" do
      Project.new(:building => false).activity.should eql('Sleeping')
    end

    it "should return Building when being build" do
      Project.new(:building => true).activity.should eql('Building')
    end
  end

  context "when returing the status" do
    before :each do
      @project = Project.new :builds => [@build = Build.new]
    end

    it "should return #{Build::SUCCESS} when the last build was successful" do
      @build.success = true
      @project.status.should eql(Build::SUCCESS)
    end

    it "should return #{Build::FAIL} when the last build was not successful" do
      @build.success = false
      @project.status.should eql(Build::FAIL)
    end

    it "should return #{Project::BUILDING} when the build is running" do
      @project.building = true
      @project.status.should eql(Project::BUILDING)
    end

    it "should return nil when there are no builds" do
      @project.builds = []
      @project.status.should be_nil
    end
  end

  it "should return when was the last build" do
    date = Time.now
    Project.new(:builds => [Build.new :created_at => date]).last_builded_at.should eql(date)
  end

  context "on update" do
    before :each do
      success_on_command
      @project = Project.create! :name => "project1",:url => "git://social", :email => "fake@mouseoverstudio.com"
    end

    it "should rename the directory when the name changes" do
      expect_for "cd #{Project::BASE_PATH} && mv project1 project2"
      @project.update_attributes :name => "project2"
    end

    it "should not rename the directory when the name doesn't change" do
      dont_accept "cd #{Project::BASE_PATH} && mv project1 project1"
      @project.update_attributes :email => "fak2@faker.com"
    end
  end

  it "should return nil as last build date when no builds exists" do
    Project.new.last_builded_at.should be_nil
  end

  it "should have name as a friendly_id" do
    name = "rails"
    Project.new(:name => name).friendly_id.should eql(name)
  end

  it "should deploy the project creating a new deploy" do
    project = Project.new
    project.deploys.should_receive(:create)
    project.deploy
  end

  it "should use master as the default branch" do
    subject.branch.should eql("master")
  end

  context "on destroy" do
    it "should execute rm -rf" do
      subject.should_receive(:execute).with("rm -rf /Users/ricardoalmeida/Documents/projects/gonow/signal/public/projects/")
      subject.destroy
    end
  end

  context "on has_file?" do
    it "should return true if the project has the file path" do
      file_exists(subject.send(:path) + '/doc/specs.html')
      subject.has_file?("doc/specs.html").should be_true
    end

    it "should return false if the project doesnt has the file path" do
      file_doesnt_exists(subject.send(:path) + '/doc/specs.html')
      subject.has_file?("doc/specs.html").should be_false
    end
  end
end

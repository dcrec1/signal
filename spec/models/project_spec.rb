require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  should_validate_presence_of :name, :url, :email
  should_have_many :builds

  it "should have public/projects as the projects base path" do
    Project::BASE_PATH.should eql("#{RAILS_ROOT}/public/projects")
  end

  it "should return the path of the project" do
    name = "yellow"
    Project.new(:name => name).path.should eql("#{Project::BASE_PATH}/#{name}")
  end

  it "should clone a repository after a project is created" do
    project = Project.new :name => "social", :url => "git://social", :email => "fake@mouseoverstudio.com"
    expect_for "cd #{Project::BASE_PATH} && git clone #{project.url} #{project.name}"
    project.save
  end

  context "responding to build" do
    before :each do
      @project = Project.new
    end

    it "builds the project creating a new build" do
      @project.builds.should_receive(:create)
      @project.build
    end

    it "should clean the cache at last" do
      @project.should_receive(:builds).ordered.and_return(mock(Object, :create => nil))
      @project.should_receive(:clean_cache).ordered
      @project.build
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

    it "should return an empty string when there are no builds" do
      @project.builds = []
      @project.status.should be_empty
    end
  end

  context "cleaning the cache" do
    before :all do
      @rails_root = RAILS_ROOT
      RAILS_ROOT = "/fake"
      FakeFS.activate!
      @name = ":name"
      @project = Project.new(:name => @name)
    end

    %w(index projects projects/status projects/:name).each do |name|
      it "should delete public/cache/#{name}.html" do
        file_exists "#{RAILS_ROOT}/public/cache/#{name}.html"
        @project.send :clean_cache
        File.exists?("#{RAILS_ROOT}/public/cache/#{name}.html").should be_false
      end
    end

    after :all do
      FakeFS.deactivate!
      RAILS_ROOT = @rails_root
    end
  end

  it "should return when was the last build" do
    date = Time.now
    Project.new(:builds => [Build.new :created_at => date]).last_builded_at.should eql(date)
  end

  it "should return nil as last build date when no builds exists" do
    Project.new.last_builded_at.should be_nil
  end

  it "should have name as a friendly_id" do
    name = "rails"
    Project.new(:name => name).friendly_id.should eql(name)
  end
end

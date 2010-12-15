require 'spec_helper'

describe ProjectsHelper do
  include ProjectsHelper

  context "returning the build date for a project" do
    it "should return an empty string when the project doesn't have builds" do
      build_date_for(Project.new).should be_empty
    end

    it "should return the time ago it was build" do
      date = Time.now
      result = "#{time_ago_in_words(date)} #{I18n.t(:ago)}"
      build_date_for(Project.new :builds => [Build.new(:created_at => date)]).should eql(result)
    end
  end
end

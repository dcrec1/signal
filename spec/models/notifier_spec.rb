require "spec_helper"

describe Notifier do
  let(:build) { Factory.build :build}

  before(:each) { success_on_command }

  context "delivering fail notification" do
    let(:subject) { Notifier.fail_notification(build) }

    it "should deliver to project email" do
       subject.to.should == [build.project.email]
    end

    it "should set '[Signal] PROJECT_NAME failed' as the subject" do
      subject.subject.should == "[Signal] #{build.project.name} failed"
    end

    it "should deliver from signal@MAILER_DOMAIN" do
      subject.from.should == ["signal@#{SignalCI::Application::MAILER['domain']}"]
    end

    it "should deliver as HTML with chartset UTF-8" do
      subject.header['content-type'].to_s.should eql("text/html; charset=UTF-8")
    end
  end

  context "delivering fix notification" do
    let(:subject) { Notifier.fix_notification build }

    it "should deliver to project email" do
      subject.to.should == [build.project.email]
    end

    it "should set '[Signal] PROJECT_NAME fixed' as the subject" do
      subject.subject.should eql("[Signal] #{build.project.name} fixed")
    end

    it "should deliver from signal@MAILER_DOMAIN" do
      subject.from.should == ["signal@#{SignalCI::Application::MAILER['domain']}"]
    end
  end
end

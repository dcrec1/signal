require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Notifier do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  context "delivering fail notification" do
    before :all do
      @address = "all@mouseoverstudio.com"
      @name = "rails"
      @email = Notifier.deliver_fail_notification Build.new(:project => Project.new(:email => @address, :name => @name))
    end

    it "should deliver to project email" do
       @email.should deliver_to(@address)
    end

    it "should set '[Signal] PROJECT_NAME failed' as the subject" do
      @email.should have_subject("[Signal] #{@name} failed")
    end

    it "should deliver from signal@MAILER_DOMAIN" do
      @email.should deliver_from("signal@#{MAILER['domain']}")
    end
  end
end

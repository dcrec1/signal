require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Deploy do
  before(:each) do
    @valid_attributes = {
      :project => ,
      :output => "value for output",
      :success => false
    }
  end

  it "should create a new instance given valid attributes" do
    Deploy.create!(@valid_attributes)
  end
end

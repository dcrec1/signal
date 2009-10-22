require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/deploys/show.html.erb" do
  include DeploysHelper
  before(:each) do
    assigns[:deploy] = @deploy = stub_model(Deploy,
      :project => ,
      :output => "value for output",
      :success => false
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(//)
    response.should have_text(/value\ for\ output/)
    response.should have_text(/false/)
  end
end


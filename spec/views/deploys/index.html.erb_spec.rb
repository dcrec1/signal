require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/deploys/index.html.erb" do
  include DeploysHelper
  
  before(:each) do
    assigns[:deploys] = [
      stub_model(Deploy,
        :project => ,
        :output => "value for output",
        :success => false
      ),
      stub_model(Deploy,
        :project => ,
        :output => "value for output",
        :success => false
      )
    ]
  end

  it "renders a list of deploys" do
    render
    response.should have_tag("tr>td", .to_s, 2)
    response.should have_tag("tr>td", "value for output".to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
  end
end


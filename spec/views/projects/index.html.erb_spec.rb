require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects/index.html.erb" do
  include ProjectsHelper
  
  before(:each) do
    assigns[:projects] = [
      stub_model(Project,
        :name => "value for name",
        :url => "value for url",
        :email => "value for email"
      ),
      stub_model(Project,
        :name => "value for name",
        :url => "value for url",
        :email => "value for email"
      )
    ]
  end

  it "renders a list of projects" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for url".to_s, 2)
    response.should have_tag("tr>td", "value for email".to_s, 2)
  end
end


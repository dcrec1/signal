require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/deploys/new.html.erb" do
  include DeploysHelper
  
  before(:each) do
    assigns[:deploy] = stub_model(Deploy,
      :new_record? => true,
      :project => ,
      :output => "value for output",
      :success => false
    )
  end

  it "renders new deploy form" do
    render
    
    response.should have_tag("form[action=?][method=post]", deploys_path) do
      with_tag("input#deploy_project[name=?]", "deploy[project]")
      with_tag("textarea#deploy_output[name=?]", "deploy[output]")
      with_tag("input#deploy_success[name=?]", "deploy[success]")
    end
  end
end



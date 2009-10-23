Given /^I have a project$/ do
  @project = Project.create! :name => "whatever", :url => "fake", :email => "fake2"
end

Then /^a new project should be created$/ do
  Project.count.should == 1
end

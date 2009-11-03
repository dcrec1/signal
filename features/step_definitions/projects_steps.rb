Given /^I have a project$/ do
  @project = Project.create! :name => "whatever", :url => "fake", :email => "fake2"
end

When /^I request '(.*)'$/ do |path|
  visit path
end

Then /^a new project should be created$/ do
  Project.count.should == 1
end

Then /^a new build should be created$/ do
  @build = @subject = Build.first
end

Then /^a new deploy should be created$/ do
  @deploy = @subject = Deploy.first
end

Then /^I should see the author of the build$/ do
  response.should contain(@build.author)
end

Then /^I should see tha name of the project$/ do
  response.should contain(@subject.project.name)
end

Then /^I should see the output of the deploy$/ do
  response.should contain(@deploy.output)
end

Then /^I should get a XML document$/ do
  response.body.should_not be_empty
end
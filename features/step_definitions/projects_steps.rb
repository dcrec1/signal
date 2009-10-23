Given /^I have a project$/ do
  @project = Project.create! :name => "whatever", :url => "fake", :email => "fake2"
end

Then /^a new project should be created$/ do
  Project.count.should == 1
end

Then /^a new build should be created$/ do
  @build = Build.first
end

Then /^I should see the author of the build$/ do
  response.should contain(@build.author)
end

Then /^I should see tha name of the project$/ do
  response.should contain(@build.project.name)
end

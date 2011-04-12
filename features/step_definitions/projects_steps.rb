Given /^I have a project$/ do
  @project = Project.create! :name => "whatever", :url => "fake", :email => "fake2"
end

Given /^I have a project with name "([^"]*)"$/ do |arg1|
  @project = Project.create! :name => name, :url => "fake", :email => "fake2"
end

When /^I request '(.*)'$/ do |path|
  visit path
end

When /^I request '(.*)' for created project$/ do |path|
  visit path.gsub("1", "#{@project.id}")
end

When /^a new project should be created$/ do
  Project.count.should == 1
end

Then /^a new build should be created$/ do
  @build = @subject = Build.first
end

Then /^a new deploy should be created$/ do
  @deploy = @subject = Deploy.first
end

Then /^I should see the author of the build$/ do
  page.should have_xpath('//*', :text => @build.author)
end

Then /^I should see the name of the project$/ do
  page.should have_xpath('//*', :text => @project.name)
end

Then /^I should see the output of the deploy$/ do
  Then "I should see \"#{@deploy.output.gsub("\n", "")}\""
end

Then /^I should get a XML document$/ do
  page.body.should_not be_empty
end

Then /^I should receive a link for the feed of all projects$/ do
  page.should have_xpath('//link[@type="application/rss+xml"]')
end

Then /^I should receive a link for the feed of the project$/ do
  page.should have_xpath("//link[@type='application/rss+xml'][@href='/projects/#{@project.name}.rss'][@title='#{@project.name}']")
end

Then /^I should see url field with type text$/ do
  find(:xpath, '//*[@id="project_url" and @type="text"]').should_not raise_exception(Capybara::ElementNotFound)
end

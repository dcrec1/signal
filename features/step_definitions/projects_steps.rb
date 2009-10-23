Then /^a new project should be created$/ do
  Project.count.should == 1
end

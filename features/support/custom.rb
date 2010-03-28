Before do
  Kernel.stub!(:system)
  repo = Git.open RAILS_ROOT
  Git.stub!(:open).and_return(repo)
  File.open(RAILS_ROOT + "/tmp/whatever", 'w') { |f| f.write "fqwfwefwejkiwegw" }
end

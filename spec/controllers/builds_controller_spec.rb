require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuildsController do
  should_behave_like_resource :in => :projects, :actions => [:show]
end

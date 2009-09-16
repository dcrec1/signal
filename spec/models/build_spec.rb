require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Build do
  should_belong_to :project
  should_validate_presence_of :project, :log, :success
end

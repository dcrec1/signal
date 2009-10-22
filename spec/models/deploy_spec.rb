require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Deploy do
  should_validate_presence_of :project, :output, :success
end

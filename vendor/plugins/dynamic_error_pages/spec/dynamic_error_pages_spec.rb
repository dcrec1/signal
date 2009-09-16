require File.dirname(__FILE__) + '/spec_helper.rb'

describe ActionController::Base do

  before :each do
    @object = ActionController::Base.new
  end
  
  %w(ActiveRecord::RecordNotFound ActiveRecord::RecordInvalid ActionController::RoutingError ActionController::UnknownController ActionController::UnknownAction ActionController::MethodNotAllowed).each do |exception|
  
    eval "module #{exception.split("::").first}; class #{exception.split("::").last}; end; end;"
    
    it "should render application/404 on #{exception}" do
      @object.should_receive(:render).with(:template => "application/404", :status => "404")
      @object.rescue_action_in_public(eval(exception).new)
    end
  end
  
  it "should render application/500 on unknow exceptions" do
    @object.should_receive(:render).with(:template => "application/500", :status => "500")
    @object.rescue_action_in_public(Exception.new)
  end
end

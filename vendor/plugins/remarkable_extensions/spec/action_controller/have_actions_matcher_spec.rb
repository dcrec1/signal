require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
 
describe 'have_actions' do
  include FunctionalBuilder
 
  before(:each) do
    @controller = define_controller :Comments do
      def index
      end
 
      def create
      end
 
      def another_method
      end
      hide_action :another_method
    end.new
 
    self.class.subject { @controller }
  end
 
  describe 'messages' do
    it 'should contain a description message' do
      have_action(:index).description.should == 'respond to index'
    end
 
    it 'should set has_action? message' do
      @matcher = have_action(:show)
      @matcher.matches?(@controller)
      @matcher.failure_message.should == 'Expected controller to respond to show'
    end
  end
 
  describe 'matcher' do
    should_have_action :index
    should_have_actions :index, :create
 
    should_not_have_action :destroy
    should_not_have_actions :destroy, :update
 
    should_not_have_action :another_method
  end
 
end

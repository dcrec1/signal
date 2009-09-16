# This is based on Shoulda model builder for Test::Unit.
#
module FunctionalBuilder
  def self.included(base)
    base.class_eval do
      return unless base.name =~ /^Spec/

      base.controller_name 'application'
      base.integrate_views false

      after(:each) do
        if @defined_constants
          @defined_constants.each do |class_name| 
            Object.send(:remove_const, class_name)
          end
        end
      end
    end

    base.extend ClassMethods
  end

  def build_response(&block)
    klass = defined?(ExamplesController) ? ExamplesController : define_controller('Examples')
    block ||= lambda { render :nothing => true }
    klass.class_eval { define_method(:example, &block) }

    @controller = klass.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    get :example

    self.class.subject { @controller }
  end

  def define_controller(class_name, &block)
    class_name = class_name.to_s
    class_name << 'Controller' unless class_name =~ /Controller$/
    define_constant(class_name, ApplicationController, &block)
  end

  def define_constant(class_name, base, &block)
    class_name = class_name.to_s.camelize

    klass = Class.new(base)
    Object.const_set(class_name, klass)

    klass.class_eval(&block) if block_given?

    @defined_constants ||= []
    @defined_constants << class_name

    klass
  end

  module ClassMethods
    def generate_macro_stubs_specs_for(matcher, *args)
      stubs_args = args.dup

      options = args.extract_options!
      expectations_args = (args << options.merge(:with_expectations => true))

      describe 'macro stubs' do
        before(:each) do
          @controller = TasksController.new
          @request    = ActionController::TestRequest.new
          @response   = ActionController::TestResponse.new
        end

        expects :new, :on => String, :with => 'ola', :returns => 'ola'
        get :new

        it 'should run stubs by default' do
          String.should_receive(:stub!).with(:new).and_return(@mock=mock('chain'))
          @mock.should_receive(:and_return).with('ola').and_return('ola')

          send(matcher, *stubs_args).matches?(@controller)
        end

        it 'should run expectations' do
          String.should_receive(:should_receive).with(:new).and_return(@mock=mock('chain'))
          @mock.should_receive(:with).with('ola').and_return(@mock)
          @mock.should_receive(:exactly).with(1).and_return(@mock)
          @mock.should_receive(:times).and_return(@mock)
          @mock.should_receive(:and_return).with('ola').and_return('ola')

          send(matcher, *expectations_args).matches?(@controller)
        end
      end

    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'have_filter' do
  include FunctionalBuilder

  describe 'have_before_filter' do
    before(:each) do
      @controller = define_controller :Posts do
        before_filter :always
        before_filter :require_user, :only => [:edit, :update, :destroy]
        before_filter :require_no_user, :except => [:new, :create]
      end.new
    end

    describe 'messages' do
      it 'should contain a description message' do
        matcher = have_before_filter(:require_user)
        matcher.on(:new, :create)
        matcher.description.should == 'require user before :new and :create actions'
      end

      it 'should set has_filter? message' do
        matcher = have_before_filter(:foo)
        matcher.matches?(@controller)
        matcher.failure_message.should == 'Expected controller to have before filter :foo'
      end

      it 'should set only_matches? message' do
        matcher = have_before_filter(:require_user)
        matcher.on(:new).matches?(@controller)
        matcher.failure_message.should == 'Expected controller to have before filter :require_user on action :new, got only on [:edit, :destroy, :update]'
      end

      it 'should set except_matches? message' do
        matcher = have_before_filter(:require_no_user)
        matcher.on(:new).matches?(@controller)
        matcher.failure_message.should == 'Expected controller to have before filter :require_no_user on action :new, got all except [:new, :create]'
      end
    end

    describe 'matchers' do
      it { should_not have_before_filter(:unknown) }

      it { should have_before_filter(:always, :on => [:edit, :update]) }

      it { should have_before_filter(:require_user, :on => :edit) }
      it { should have_before_filter(:require_user, :on => [:edit, :update]) }
      it { should_not have_before_filter(:require_user, :on => :new) }

      it { should have_before_filter(:require_no_user, :on => :edit) }
      it { should have_before_filter(:require_no_user, :on => [:edit, :update]) }
      it { should_not have_before_filter(:require_no_user, :on => :new) }
    end

    describe 'macros' do
      should_not_have_before_filter(:unknown)

      should_have_before_filter(:always, :on => [:edit, :update])

      should_have_before_filter(:require_user, :on => :edit)
      should_have_before_filter(:require_user, :on => [:edit, :update])
      should_not_have_before_filter(:require_user, :on => :new)

      should_have_before_filter(:require_no_user, :on => :edit)
      should_have_before_filter(:require_no_user, :on => [:edit, :update])
      should_not_have_before_filter(:require_no_user, :on => :new)

      should_have_before_filter :require_user, :only => [:edit, :update, :destroy]
      should_not_have_before_filter :require_user, :only => :edit
    end
  end

  describe 'have_after_filter' do
    before(:each) do
      @controller = define_controller :Posts do
        after_filter :always
        after_filter :require_user, :only => [:edit, :update]
        after_filter :require_no_user, :except => [:new, :create]
      end.new
    end

    describe 'messages' do
      it 'should contain a description message' do
        matcher = have_after_filter(:require_user)
        matcher.on(:new, :create)
        matcher.description.should == 'require user after :new and :create actions'
      end

      it 'should set has_filter? message' do
        matcher = have_after_filter(:foo)
        matcher.matches?(@controller)
        matcher.failure_message.should == 'Expected controller to have after filter :foo'
      end

      it 'should set only_matches? message' do
        matcher = have_after_filter(:require_user)
        matcher.on(:new).matches?(@controller)
        matcher.failure_message.should == 'Expected controller to have after filter :require_user on action :new, got only on [:edit, :update]'
      end

      it 'should set except_matches? message' do
        matcher = have_after_filter(:require_no_user)
        matcher.on(:new).matches?(@controller)
        matcher.failure_message.should == 'Expected controller to have after filter :require_no_user on action :new, got all except [:new, :create]'
      end
    end

    describe 'matchers' do
      it { should_not have_after_filter(:unknown) }

      it { should have_after_filter(:always, :on => [:edit, :update]) }

      it { should have_after_filter(:require_user, :on => :edit) }
      it { should have_after_filter(:require_user, :on => [:edit, :update]) }
      it { should_not have_after_filter(:require_user, :on => :new) }

      it { should have_after_filter(:require_no_user, :on => :edit) }
      it { should have_after_filter(:require_no_user, :on => [:edit, :update]) }
      it { should_not have_after_filter(:require_no_user, :on => :new) }
    end

    describe 'macros' do
      should_not_have_after_filter(:unknown)

      should_have_after_filter(:always, :on => [:edit, :update])

      should_have_after_filter(:require_user, :on => :edit)
      should_have_after_filter(:require_user, :on => [:edit, :update])
      should_not_have_after_filter(:require_user, :on => :new)

      should_have_after_filter(:require_no_user, :on => :edit)
      should_have_after_filter(:require_no_user, :on => [:edit, :update])
      should_not_have_after_filter(:require_no_user, :on => :new)
    end
  end
end

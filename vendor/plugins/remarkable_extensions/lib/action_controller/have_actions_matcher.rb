module Remarkable
  module ActionController
    module Matchers
      # Do not inherit from ActionController::Base since it don't need all macro stubs behavior.
      class HaveActionsMatcher < Remarkable::Base #:nodoc:
        arguments :collection => :actions, :as => :action
 
        collection_assertions :has_action?
 
        protected
 
          def has_action?
            subject_class.action_methods.include?(@action.to_s)
          end
      end
 
      # Checks if the controller respond to the given actions. You might want
      # use this matcher in its negative form though, to ensure that you are
      # not exposing a method to a resource.
      #
      # == Examples
      #
      # should_have_action :destroy
      # should_not_have_actions :new, :create
      #
      # it { should have_action(:destroy) }
      # it { should_not have_actions(:new, :create) }
      #
      def have_actions(*args, &block)
        HaveActionsMatcher.new(*args, &block).spec(self)
      end
      alias :have_action :have_actions
 
    end
  end
end

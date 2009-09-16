module Remarkable
  module ActionController
    module Matchers
      # Do not inherit from ActionController::Base since it don't need all macro stubs behavior.
      class HaveFilterMatcher < Remarkable::Base #:nodoc:
        arguments :type, :name

        optionals :on, :only, :splat => true
        assertions :has_filter?, :on?, :except?, :only?

        before_assert do
          @options[:on] = [*@options[:on]].compact
          @options[:only] = [*@options[:only]].compact
        end

        protected

          def has_filter?
            @filter = filter
            !@filter.nil?
          end

          def only?
            return true unless @options[:on].empty?
            sort(@options[:only]) == sort(only_actions)
          end

          def on?
            return true if @options[:on].empty? || only_actions.empty?

            @options[:on].each do |action|
              next if only_actions.include?(action.to_sym)
              return false, :actual => only_actions.inspect, :action => action.to_sym.inspect
            end
            true
          end

          def except?
            return true if @options[:on].empty? || except_actions.empty?

            @options[:on].each do |action|
              next unless except_actions.include?(action.to_sym)
              return false, :actual => except_actions.inspect, :action => action.to_sym.inspect
            end
            true
          end

        private

          def only_actions
            @only_actions ||= @filter.options[:only].to_a.map{ |a| a.to_sym }
          end

          def except_actions
            @except_actions ||= @filter.options[:except].to_a.map{ |a| a.to_sym }
          end

          def filter
            subject_class.filter_chain.select { |f| f.method == @name.to_sym && f.type == @type }.first
          end

          def interpolation_options
            options = {}
            options[:macro] = Remarkable.t(@type, :scope => matcher_i18n_scope, :default => @type.to_s)
            options[:human_name] = Remarkable.t(@name, :scope => matcher_i18n_scope, :default => @name.to_s.gsub("_", " "))
            options
          end

          def sort(array)
            array.map { |action| action.to_s }.sort
          end

      end

      # Checks if the controller has a before filter.
      #
      # == Options
      #
      # * <tt>on</tt> - the actions that perform the filter. In the negate form
      # represents actions that should not perform the filter.
      #
      # == Examples
      #
      # should_have_before_filter :login_required
      # should_have_before_filter :login_required, :on => :edit
      # should_have_before_filter :login_required, :on => [:edit, :create]
      #
      # it { should have_before_filter :login_required }
      # it { should have_before_filter :login_required, :on => :edit }
      # it { should have_before_filter :login_required, :on => [:edit, :create] }
      #
      def have_before_filter(*args, &block)
        HaveFilterMatcher.new(:before, *args, &block).spec(self)
      end

      # Checks if the controller has an after filter.
      #
      # == Options
      #
      # * <tt>on</tt> - the actions that perform the filter. In the negate form
      # represents actions that should not perform the filter.
      #
      # == Examples
      #
      # should_have_after_filter :process_content
      # should_have_after_filter :process_content, :on => :edit
      # should_have_after_filter :process_content, :on => [:edit, :create]
      #
      # it { should have_after_filter :process_content }
      # it { should have_after_filter :process_content, :on => :edit }
      # it { should have_after_filter :process_content, :on => [:edit, :create] }
      #
      def have_after_filter(*args, &block)
        HaveFilterMatcher.new(:after, *args, &block).spec(self)
      end

    end
  end
end

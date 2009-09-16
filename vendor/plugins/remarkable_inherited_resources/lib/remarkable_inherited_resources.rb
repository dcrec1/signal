module Remarkable
  module InheritedResources
    module Matchers
      class HaveANameMatcher < Remarkable::ActiveRecord::Base
        arguments :name
        
        assertion :has_a_name?
        
        def has_a_name?
          @subject.names.include? @name.to_s
        end
      end

      def have_a_name(attribute)
        HaveANameMatcher.new(attribute).spec(self)
      end

    end
  end
end
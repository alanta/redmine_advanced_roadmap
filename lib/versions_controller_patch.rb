require_dependency "versions_controller"

module VersionsControllerPatch
  def self.included(base)
    base.class_eval do

      def show
        @issues = @version.sorted_fixed_issues
      end
    
    end
  end
end

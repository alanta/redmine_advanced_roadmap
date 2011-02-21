require_dependency "versions_controller"

module VersionsControllerPatch
  def self.included(base)
    base.class_eval do

      def index_with_sort
        index_without_sort
        Version.sort_versions(@versions)
      end
      alias_method_chain :index, :sort

      def show
        @issues = @version.sorted_fixed_issues
      end
    
    end
  end
end

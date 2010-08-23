require_dependency "projects_controller"

module ProjectsControllerPatch
  def self.included(base)
    base.class_eval do
      def roadmap_with_advanced_info
        roadmap_without_advanced_info
      end
      alias_method_chain :roadmap, :advanced_info
    end
  end
end

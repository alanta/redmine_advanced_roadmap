module ProjectsControllerPatch

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method_chain :roadmap, :advanced_info
    end
  end

  module ClassMethods
  end

  module InstanceMethods

    def roadmap_with_advanced_info
      roadmap_without_advanced_info
    end

  end

end

ProjectsController.send(:include, ProjectsControllerPatch)

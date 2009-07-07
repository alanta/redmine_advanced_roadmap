module ProjectPatch

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      has_many :milestones
    end
  end

  module ClassMethods
  end

  module InstanceMethods
  end

end

Project.send(:include, ProjectPatch)

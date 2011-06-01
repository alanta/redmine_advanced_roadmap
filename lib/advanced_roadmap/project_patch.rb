require_dependency "projects_controller"

module ProjectPatch
  def self.included(base)
    base.class_eval do
      has_many :milestones
    end
  end
end

module VersionPatch

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      belongs_to :milestone
      alias_method_chain :completed_pourcent, :advanced_info
      alias_method_chain :closed_pourcent, :advanced_info
    end
  end

  module ClassMethods
  end

  module InstanceMethods

    def completed_pourcent_with_advanced_info
      calculate_advance_info unless @total_ratio
      @total_ratio
    end

    def closed_pourcent_with_advanced_info
      calculate_advance_info unless @total_finished_ratio
      @total_finished_ratio
    end

    def rest_hours
      calculate_advance_info unless @total_pending
      @total_pending
    end

    def closed_spent_hours
      if !@closed_spent_hours
        @closed_spent_hours = 0.0
        fixed_issues.each do |issue|
          if issue.closed?
            @closed_spent_hours += issue.spent_hours
          end
        end
      end
      @closed_spent_hours
    end

    def calculate_advance_info
      total_estimated = 0.0
      total_spent = 0.0
      @total_pending = 0.0
      @total_finished_ratio = 0.0
      @total_ratio = 0.0
      if fixed_issues.size > 0
        fixed_issues.each do |issue|
          if issue.estimated_hours && issue.done_ratio
            ratio = issue.spent_hours / ((issue.estimated_hours * issue.done_ratio) / 100.0)
          end
          total_estimated += issue.estimated_hours ? issue.estimated_hours : 0.0
          total_spent += issue.spent_hours ? issue.spent_hours : 0.0
          @total_pending += issue.rest_hours ? issue.rest_hours : 0.0
          if issue.spent_hours && issue.rest_hours
            issue_time = (issue.spent_hours + issue.rest_hours) * issue.done_ratio
            if issue.closed?
              @total_finished_ratio += issue_time
            end
            @total_ratio += issue_time
          end
        end
        if total_spent + @total_pending > 0.0
          @total_finished_ratio /= (total_spent + @total_pending)
          @total_ratio /= (total_spent + @total_pending)
        else
          @total_finished_ratio = 0.0        
          @total_ratio = 0.0        
        end
      end
    end

  end

end

Version.send(:include, VersionPatch)

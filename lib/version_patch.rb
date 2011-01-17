require_dependency "version"

module VersionPatch
  def self.included(base)
    base.class_eval do

      has_many :milestone_versions, :dependent => :destroy
      has_many :milestones, :through => :milestone_versions

      def completed_pourcent_with_advanced_info
        calculate_advance_info unless @total_ratio
        @total_ratio
      end
      alias_method_chain :completed_pourcent, :advanced_info

      def closed_pourcent_with_advanced_info
        calculate_advance_info unless @total_finished_ratio
        @total_finished_ratio
      end
      alias_method_chain :closed_pourcent, :advanced_info
  
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
            if issue.children.empty?
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
      
      def sorted_fixed_issues(options = {})
        issues = []
        conditions = {:parent_id => options[:parent]}
        conditions[:tracker_id] = options[:trackers] if options[:trackers]
        fixed_issues.visible.find(:all,
                                  :conditions => conditions,
                                  :include => [:status, :tracker, :priority],
                                  :order => "#{Tracker.table_name}.position, #{Issue.table_name}.subject").each do |issue|
          issues << issue
          issues += sorted_fixed_issues(options.merge(:parent => issue))
        end
        issues
      end
      
      def parallel_factor
        factor = 1.0
        if !(custom_field = CustomField.find(Setting.plugin_advanced_roadmap["parallel_effort_custom_field"].to_i)).nil? and
           custom_field.field_format == "float"
          if !(custom_value = CustomValue.find(:first, :conditions => {:customized_type => "Version", :customized_id => id, :custom_field_id => custom_field.id})).nil?
            factor = custom_value.value.to_f
          else
            factor = custom_field.default_value.to_f
          end
          factor = 1.0 if factor <= 0.0
        end
        factor
      end
      
      def parallel_rest_hours
        rest_hours / parallel_factor
      end
      
    end
  end
end

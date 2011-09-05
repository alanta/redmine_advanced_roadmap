require_dependency "application_helper"

module ApplicationHelperPatch
  def self.included(base)
    base.class_eval do

      def color_by_ratio(ratio)
        color = ""
        color = Setting.plugin_advanced_roadmap["color_good"] if ratio <= Setting.plugin_advanced_roadmap["ratio_good"].to_f
        color = Setting.plugin_advanced_roadmap["color_bad"] if ratio >= Setting.plugin_advanced_roadmap["ratio_bad"].to_f
        color = Setting.plugin_advanced_roadmap["color_very_bad"] if ratio >= Setting.plugin_advanced_roadmap["ratio_very_bad"].to_f
        color
      end

    end
  end
end

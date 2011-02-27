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

      def total_graph_tag(versions, totals, options = {})
        small_width = options[:small_width] || 100
        small_height = options[:small_height] || 100
        big_width = options[:big_width] || 400
        big_height = options[:big_height] || 400
        versions_names = versions.collect{|version| version.name}
        versions_percentajes = versions.collect{|version| (((version.spent_hours + version.rest_hours) * 100.0) / (totals[:spent_hours] + totals[:rest_hours]))}
        tag("embed",
            :type => "image/png",
            :src => url_for(:controller => "milestones",
                            :action => "total_graph",
                            :versions => versions_names,
                            :percentajes => versions_percentajes,
                            :size => "#{big_width}x#{big_height}"),
            :witdh => small_width,
            :height => small_height,
            :title => l(:label_click_to_enlarge_reduce),
            :style => "cursor: pointer;",
            :id => "total_graph_image",
            :onclick => "image = document.getElementById('total_graph_image'); if (image.width == #{big_width}) { image.width = #{small_width}; image.height = #{small_height}; } else { image.width = #{big_width}; image.height = #{big_height}; }")
      end

    end
  end
end

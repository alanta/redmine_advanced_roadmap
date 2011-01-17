require_dependency "application_helper"

module ApplicationHelperPatch
  def self.included(base)
    base.class_eval do

      def color_by_ratio(ratio)
        color = ""
        color = "green" if ratio < 0.5
        color = "orange" if ratio > 1.0
        color = "red" if ratio > 1.5
        color
      end

    end
  end
end

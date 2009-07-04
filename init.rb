require "redmine"
require "gravatar"
require "application"
require "projects_controller"
require "projects_controller_patch"
require "issue_patch"

load_paths.each do |path|
  Dependencies.load_once_paths.delete(path)
end

RAILS_DEFAULT_LOGGER.info "Advanced roapmap plugin for RedMine"

Redmine::Plugin.register :advanced_roapmap do
  name "Advanced roadmap plugin"
  author "Emilio Gonzalez"
  description "This is a plugin for Redmine that is used to show more information inside the Roadmap page"
  version "0.0.1"
end

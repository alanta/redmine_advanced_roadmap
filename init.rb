require "redmine"
require "gravatar"
require "application"
require "project_patch"
require "projects_controller_patch"
require "projects_helper_patch"
require "issue_patch"
require "version_patch"

load_paths.each do |path|
  Dependencies.load_once_paths.delete(path)
end

RAILS_DEFAULT_LOGGER.info "Advanced roapmap plugin for RedMine"

Redmine::Plugin.register :advanced_roapmap do
  name "Advanced roadmap plugin"
  url "http://ociotec.com/redmine/projects/show/advanced-roadmap"
  author "Emilio Gonzalez"
  author_url "http://ociotec.com"
  description "This is a plugin for Redmine that is used to show more information inside the Roadmap page"
  version "0.0.5"
  permission :manage_milestones, {:milestones => [:add, :edit, :destroy]}
end

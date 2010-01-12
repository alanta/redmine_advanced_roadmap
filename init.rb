require "redmine"
require "gravatar"
require "application_controller"
require File.dirname(__FILE__) + "/../awesome_nested_set/rails/init"
require "project_patch"
require "projects_controller_patch"
require "projects_helper_patch"
require "issue_patch"
require "version_patch"

RAILS_DEFAULT_LOGGER.info "Advanced roapmap plugin for RedMine"

Redmine::Plugin.register :advanced_roapmap do
  name "Advanced roadmap plugin"
  url "http://ociotec.com/redmine/projects/show/advanced-roadmap"
  author "Emilio Gonzalez"
  author_url "http://ociotec.com"
  description "This is a plugin for Redmine that is used to show more information inside the Roadmap page"
  version "0.0.6"
  permission :manage_milestones, {:milestones => [:add, :edit, :destroy]}
  requires_redmine :version_or_higher => "0.9.0"
end

# This plugin should be reloaded in development mode.
if RAILS_ENV == "development"
  ActiveSupport::Dependencies.load_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
end

require "redmine"
require "rubygems"
require "gravatar"
require "dispatcher"
require_dependency File.dirname(File.dirname(__FILE__)) + "/awesome_nested_set/rails/init"
Dispatcher.to_prepare do 
  begin
    require_dependency "application"
  rescue LoadError
    require_dependency "application_controller"
  end

  Issue.send(:include, IssuePatch)
  Project.send(:include, ProjectPatch)
  ProjectsController.send(:include, ProjectsControllerPatch)
  ProjectsHelper.send(:include, ProjectsHelperPatch)
  Redmine::I18n.send(:include, RedmineI18nPatch)
  Version.send(:include, VersionPatch)
end

RAILS_DEFAULT_LOGGER.info "Advanced roapmap plugin for RedMine"

Redmine::Plugin.register :advanced_roapmap do
  name "Advanced roadmap plugin"
  url "http://ociotec.com/redmine/projects/show/advanced-roadmap"
  author "Emilio Gonzalez"
  author_url "http://ociotec.com"
  description "This is a plugin for Redmine that is used to show more information inside the Roadmap page"
  version "0.1.0"
  permission :manage_milestones, {:milestones => [:add, :edit, :destroy]}
  requires_redmine :version_or_higher => "0.9.0"
end

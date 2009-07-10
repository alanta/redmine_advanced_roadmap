class MilestonesController < ApplicationController
  
  menu_item :roadmap
  before_filter :find_project, :only => [:add]
  before_filter :find_milestone, :except => [:add]
  before_filter :authorize, :except => [:show]

  def show
  end
  
  def add
    @project = Project.find(params[:id])
    @versions = @project.versions
    @milestone = @project.milestones.build(params[:milestone])
    @milestone.user_id = User.current.id
    if request.post? and @milestone.save
      if params[:versions]
        params[:versions].each do |version|
          milestone_version = MilestoneVersion.new
          milestone_version.milestone_id = @milestone.id
          milestone_version.version_id = version
          milestone_version.save
        end
       end
      flash[:notice] = l(:notice_successful_create)
      redirect_to :controller => :projects, :action => :settings, :tab => "milestones", :id => @project
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def edit
    @versions = @project.versions
    if request.post?
      versions_to_delete = @milestone.versions
      versions_to_add = []
      if params[:versions]
        params[:versions].each do |version|
          index = @milestone.versions.index(version)
          if index != nil
            versions_to_delete.remove(index)
          else
            versions_to_add << version
          end
        end
      end
    end
    if request.post? and @milestone.update_attributes(params[:milestone])
      versions_to_delete.each do |version|
        milestone_version = MilestoneVersion.find(:first, :conditions => "milestone_id = #{@milestone.id} AND version_id = #{version.id}")
        milestone_version.destroy
      end
      versions_to_add.each do |version|
        milestone_version = MilestoneVersion.new
        milestone_version.milestone_id = @milestone.id
        milestone_version.version_id = version
        milestone_version.save
      end
      flash[:notice] = l(:notice_successful_update)
      redirect_to :controller => :projects, :action => :settings, :tab => "milestones", :id => @project
    end
  end

  def destroy
    @milestone.destroy
    redirect_to :controller => :projects, :action => :settings, :tab => "milestones", :id => @project
  rescue
    flash[:error] = l(:notice_unable_delete_milestone)
    redirect_to :controller => :projects, :action => :settings, :tab => "milestones", :id => @project
  end
  
private

  def find_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_milestone
    @milestone = Milestone.find(params[:id])
    @project = @milestone.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end

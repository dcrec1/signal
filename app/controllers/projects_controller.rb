class ProjectsController < InheritedResources::Base

  caches_page :index, :show, :status

  def build
    Project.find(params[:project_id]).send_later :build
    render :nothing => true
  end

  def status
    @projects = Project.all
    render :partial => "shared/projects"
  end
end

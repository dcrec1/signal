class ProjectsController < InheritedResources::Base

  caches_page :index

  def build
    Project.find(params[:project_id]).send_later :build
    expire_page :action => :index
    render :nothing => true
  end
end

class ProjectsController < InheritedResources::Base

  caches_page :index, :show

  def build
    Project.find(params[:project_id]).send_later :build
    expire_page :action => :index
    expire_page :action => :show
    render :nothing => true
  end
end

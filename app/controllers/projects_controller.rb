class ProjectsController < InheritedResources::Base

  def build
    Project.find(params[:project_id]).send_later :build
    render :nothing => true
  end
end

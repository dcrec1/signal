class ProjectsController < InheritedResources::Base
  respond_to :html, :xml, :rss

  def build
    Project.find(params[:project_id]).send_later :build
    render :nothing => true
  end

  def fetch_status
    @projects = Project.all
    respond_to do |format|
      format.html { render :template => "shared/_projects", :layout => false }
      format.xml { render :template => "projects/status" }
    end
  end
end

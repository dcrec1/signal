class TasksController < ApplicationController
  filter_parameter_logging :password

  def index
    @tasks = Task.find(:all)
    render :text => 'index'
  end

  def new
    render :nothing => true
  end

  def show
    @task = Task.find(params[:id])

    # Multiple expects
    Task.count
    Task.max
    Task.min

    respond_to do |format|
      format.html { render :text => 'show' }
      format.xml  { render :xml => @task.to_xml }
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:notice]         = "#{@task.title(false).inspect} was removed"
    session[:last_task_id] = 37

    respond_to do |format|
     format.html { redirect_to project_tasks_url(10) }
     format.xml  { head :ok }
    end
  end
end

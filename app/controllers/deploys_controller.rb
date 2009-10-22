class DeploysController < ApplicationController
  # GET /deploys
  # GET /deploys.xml
  def index
    @deploys = Deploy.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deploys }
    end
  end

  # GET /deploys/1
  # GET /deploys/1.xml
  def show
    @deploy = Deploy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deploy }
    end
  end

  # GET /deploys/new
  # GET /deploys/new.xml
  def new
    @deploy = Deploy.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deploy }
    end
  end

  # GET /deploys/1/edit
  def edit
    @deploy = Deploy.find(params[:id])
  end

  # POST /deploys
  # POST /deploys.xml
  def create
    @deploy = Deploy.new(params[:deploy])

    respond_to do |format|
      if @deploy.save
        flash[:notice] = 'Deploy was successfully created.'
        format.html { redirect_to(@deploy) }
        format.xml  { render :xml => @deploy, :status => :created, :location => @deploy }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deploy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deploys/1
  # PUT /deploys/1.xml
  def update
    @deploy = Deploy.find(params[:id])

    respond_to do |format|
      if @deploy.update_attributes(params[:deploy])
        flash[:notice] = 'Deploy was successfully updated.'
        format.html { redirect_to(@deploy) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deploy.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deploys/1
  # DELETE /deploys/1.xml
  def destroy
    @deploy = Deploy.find(params[:id])
    @deploy.destroy

    respond_to do |format|
      format.html { redirect_to(deploys_url) }
      format.xml  { head :ok }
    end
  end
end

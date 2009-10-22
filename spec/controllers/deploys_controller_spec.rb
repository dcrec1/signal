require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DeploysController do

  def mock_deploy(stubs={})
    @mock_deploy ||= mock_model(Deploy, stubs)
  end
  
  describe "GET index" do
    it "assigns all deploys as @deploys" do
      Deploy.stub!(:find).with(:all).and_return([mock_deploy])
      get :index
      assigns[:deploys].should == [mock_deploy]
    end
  end

  describe "GET show" do
    it "assigns the requested deploy as @deploy" do
      Deploy.stub!(:find).with("37").and_return(mock_deploy)
      get :show, :id => "37"
      assigns[:deploy].should equal(mock_deploy)
    end
  end

  describe "GET new" do
    it "assigns a new deploy as @deploy" do
      Deploy.stub!(:new).and_return(mock_deploy)
      get :new
      assigns[:deploy].should equal(mock_deploy)
    end
  end

  describe "GET edit" do
    it "assigns the requested deploy as @deploy" do
      Deploy.stub!(:find).with("37").and_return(mock_deploy)
      get :edit, :id => "37"
      assigns[:deploy].should equal(mock_deploy)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created deploy as @deploy" do
        Deploy.stub!(:new).with({'these' => 'params'}).and_return(mock_deploy(:save => true))
        post :create, :deploy => {:these => 'params'}
        assigns[:deploy].should equal(mock_deploy)
      end

      it "redirects to the created deploy" do
        Deploy.stub!(:new).and_return(mock_deploy(:save => true))
        post :create, :deploy => {}
        response.should redirect_to(deploy_url(mock_deploy))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved deploy as @deploy" do
        Deploy.stub!(:new).with({'these' => 'params'}).and_return(mock_deploy(:save => false))
        post :create, :deploy => {:these => 'params'}
        assigns[:deploy].should equal(mock_deploy)
      end

      it "re-renders the 'new' template" do
        Deploy.stub!(:new).and_return(mock_deploy(:save => false))
        post :create, :deploy => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT update" do
    
    describe "with valid params" do
      it "updates the requested deploy" do
        Deploy.should_receive(:find).with("37").and_return(mock_deploy)
        mock_deploy.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :deploy => {:these => 'params'}
      end

      it "assigns the requested deploy as @deploy" do
        Deploy.stub!(:find).and_return(mock_deploy(:update_attributes => true))
        put :update, :id => "1"
        assigns[:deploy].should equal(mock_deploy)
      end

      it "redirects to the deploy" do
        Deploy.stub!(:find).and_return(mock_deploy(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(deploy_url(mock_deploy))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested deploy" do
        Deploy.should_receive(:find).with("37").and_return(mock_deploy)
        mock_deploy.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :deploy => {:these => 'params'}
      end

      it "assigns the deploy as @deploy" do
        Deploy.stub!(:find).and_return(mock_deploy(:update_attributes => false))
        put :update, :id => "1"
        assigns[:deploy].should equal(mock_deploy)
      end

      it "re-renders the 'edit' template" do
        Deploy.stub!(:find).and_return(mock_deploy(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested deploy" do
      Deploy.should_receive(:find).with("37").and_return(mock_deploy)
      mock_deploy.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the deploys list" do
      Deploy.stub!(:find).and_return(mock_deploy(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(deploys_url)
    end
  end

end

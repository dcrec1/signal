require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuildsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "builds", :action => "index").should == "/builds"
    end
  
    it "maps #new" do
      route_for(:controller => "builds", :action => "new").should == "/builds/new"
    end
  
    it "maps #show" do
      route_for(:controller => "builds", :action => "show", :id => "1").should == "/builds/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "builds", :action => "edit", :id => "1").should == "/builds/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "builds", :action => "create").should == {:path => "/builds", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "builds", :action => "update", :id => "1").should == {:path =>"/builds/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "builds", :action => "destroy", :id => "1").should == {:path =>"/builds/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/builds").should == {:controller => "builds", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/builds/new").should == {:controller => "builds", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/builds").should == {:controller => "builds", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/builds/1").should == {:controller => "builds", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/builds/1/edit").should == {:controller => "builds", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/builds/1").should == {:controller => "builds", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/builds/1").should == {:controller => "builds", :action => "destroy", :id => "1"}
    end
  end
end

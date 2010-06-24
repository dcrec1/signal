def should_behave_like_resource(opts = {})
  before :each do
    @opts = opts
    controller.stub!(:require_owner)
  end

  def class_for(str)
    str.capitalize.constantize
  end

  def clazz
    described_class.to_s.gsub("Controller", '').singularize.constantize
  end

  def model
    clazz.to_s.underscore
  end

  def models
    model.pluralize
  end

  def mocked_model(stubs={})
    @mock ||= mock_model(clazz, stubs)
    @mock.stub!(:to_json).and_return("{'a' => 'b'}")
    @mock.stub!(:to_xml).and_return("<a>b</a>")
    invalid = (stubs[:update_attributes] == false || stubs[:save] == false)
    @mock.stub!(:errors).and_return(invalid ? [mock(Object)] : [])
    @mock
  end

  def mocked_model_id
    mocked_model.id.to_s
  end

  def model_url
    url, params = ""
    for i in -1..(parents.size - 1)
      url, params = "#{parent_name(i)}_#{url}", ",mocked_parent(#{i})#{params}"
    end
    eval "#{url}url(#{params[1, params.size]})"
  end

  def models_url
    url, params = "#{models}_url", ""
    for i in 0..(parents.size - 1)
      url, params = "#{parent_name(i)}_#{url}", ",mocked_parent(#{i})#{params}"
    end
    eval "#{url}(#{params[1, params.size]})"
  end

  def parents
    [@opts[:in]].flatten.compact
  end

  def parent_name(i)
    return model if i == -1
    parents[parents.size - 1 - i].to_s.singularize
  end

  def parent_class(i)
    parent_name(i).classify.constantize
  end

  def parent_id(i)
    return mocked_model_id if i == -1
    @parents_id = [] if @parents_id.nil?
    @parents_id[i] ||= rand(100).to_s
  end

  def mocked_parent(i)
    return mocked_model if i == -1
    @mocked_parents = [] if @mocked_parents.nil?
    return @mocked_parents[i] unless @mocked_parents[i].nil?
    @mocked_parents[i] = mock_model(parent_class(i))
    @mocked_parents[i].stub!(parent_name(i - 1).pluralize).and_return(mocked_childs(i))
    @mocked_parents[i]
  end

  def mocked_childs(i)
    collection = [mocked_parent(i - 1)]
    collection.stub!(:find).with(parent_id(i - 1)).and_return(collection.first)
    collection.stub!(:find).with(:all).and_return(collection)
    collection.stub!(:build).and_return(collection.first)
    collection
  end

  def param
    @opts[:param]
  end

  def param_finder
    param.nil? ? :find :"find_by_#{param}"
  end

  def parameters
    params = {}
    for i in 0..(parents.size - 1)
      id = parent_id(i)
      parent_class(i).stub!(param_finder).with(id).and_return(mocked_parent(i))
      params[param || "#{parent_name(i)}_id"] = id
    end
    params
  end

  def nested?
    parents.size > 0
  end

  def should_show(opts, action)
    except = opts[:except]
    return false if (!except.nil? and [except].flatten.include?(action))
    actions = opts[:actions]
    actions.nil? or [actions].flatten.include?(action)
  end

  def formats_include_html(opts)
    formats = opts[:formats]
    formats.nil? or formats.include?(:html)
  end

  def formats_include_json(opts)
    formats = opts[:formats]
    !formats.nil? && formats.include?(:json)
  end

  def formats_include_xml(opts)
    formats = opts[:formats]
    !formats.nil? && formats.include?(:xml)
  end

  def formats_include_rss(opts)
    formats = opts[:formats]
    !formats.nil? && formats.include?(:rss)
  end

  describe "GET index" do
    it "assigns all #{models} as @#{models}" do
      clazz.stub!(:find).with(:all).and_return([mocked_model])
      get :index, parameters
      assigns[models].should == [mocked_model]
    end if formats_include_html(opts)

    it "responds as an rss" do
      clazz.stub!(:find).with(:all).and_return([mocked_model])
      get :index, parameters.merge(:format => :rss)
      response.should render_template("index.rss.builder")
    end if formats_include_rss(opts)
  end if should_show(opts, :index)

  describe "GET show" do
    it "assigns the requested #{model} as @#{model}" do
      clazz.stub!(:find).with(mocked_model_id).and_return(mocked_model)
      get :show, {:id => mocked_model_id}.merge(parameters)
      assigns[model].should equal(mocked_model)
    end if formats_include_html(opts)

    it "returns a #{model} as json" do
      clazz.stub!(:find).with(mocked_model_id).and_return(mocked_model)
      get :show, {:format => "json", :id => mocked_model_id}.merge(parameters)
      response.code.should_not eql("406")
    end if formats_include_json(opts)

    it "returns a #{model} as xml" do
      clazz.stub!(:find).with(mocked_model_id).and_return(mocked_model)
      get :show, {:format => "xml", :id => mocked_model_id}.merge(parameters)
      response.code.should_not eql("406")
    end if formats_include_xml(opts)
  end if should_show(opts, :show)

  describe "GET new" do
    it "assigns a new #{model} as @#{model}" do
      clazz.stub!(:new).and_return(mocked_model)
      get :new, parameters
      assigns[model].should equal(mocked_model)
    end if formats_include_html(opts)
  end if should_show(opts, :new)

  describe "GET edit" do
    it "assigns the requested #{model} as @#{model}" do
      clazz.stub!(:find).with(mocked_model_id).and_return(mocked_model)
      get :edit, {:id => mocked_model_id}.merge(parameters)
      assigns[model].should equal(mocked_model)
    end if formats_include_html(opts)
  end if should_show(opts, :edit)

  describe "POST create" do

    describe "with valid parameters" do
      it "assigns a newly created #{model} as @#{model}" do
        clazz.stub!(:new).with({'these' => 'parameters'}).and_return(mocked_model(:save => true))
        post :create, {model => {:these => 'parameters'}}.merge(parameters)
        assigns[model].should equal(mocked_model)
      end if formats_include_html(opts)
    end
  end if should_show(opts, :create)

  describe "PUT update" do

    describe "with valid parameters" do
      it "updates the requested #{model}" do
        clazz.should_receive(:find).with(mocked_model_id).and_return(mocked_model) unless nested?
        mocked_model.should_receive(:update_attributes).with({'these' => 'parameters'})
        put :update, {:id => mocked_model_id, model => {:these => 'parameters'}}.merge(parameters)
      end if formats_include_html(opts)

      it "assigns the requested #{model} as @#{model}" do
        clazz.stub!(:find).and_return(mocked_model(:update_attributes => true))
        put :update, {:id => mocked_model_id}.merge(parameters)
        assigns[model].should equal(mocked_model)
      end if formats_include_html(opts)
    end

    describe "with invalid parameters" do
      it "updates the requested #{model}" do
        clazz.should_receive(:find).with(mocked_model_id).and_return(mocked_model) unless nested?
        mocked_model.should_receive(:update_attributes).with({'these' => 'parameters'})
        put :update, {:id => mocked_model_id, model => {:these => 'parameters'}}.merge(parameters)
      end if formats_include_html(opts)

      it "assigns the #{model} as @#{model}" do
        clazz.stub!(:find).and_return(mocked_model(:update_attributes => false))
        put :update, {:id => mocked_model_id}.merge(parameters)
        assigns[model].should equal(mocked_model)
      end if formats_include_html(opts)
    end

  end if should_show(opts, :update)

  describe "DELETE destroy" do
    it "destroys the requested #{model}" do
      clazz.should_receive(:find).with(mocked_model_id).and_return(mocked_model) unless nested?
      mocked_model.should_receive(:destroy)
      delete :destroy, {:id => mocked_model_id}.merge(parameters)
    end if formats_include_html(opts)
  end if should_show(opts, :destroy)
end
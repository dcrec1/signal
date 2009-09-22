ActionController::Routing::Routes.draw do |map|
  map.resources :projects do |project|
    project.resources :builds
    project.connect 'build', :controller => 'projects', :action => 'build'
  end
  map.root :controller => "projects"
  map.metrics "/projects/:name/tmp/metric_fu/output/index.html", :controller => nil
end

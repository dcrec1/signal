ActionController::Routing::Routes.draw do |map|
  map.resources :projects do |project|
    project.resources :builds
    project.connect 'build', :controller => 'projects', :action => 'build'
  end
  map.root :controller => "projects"
end

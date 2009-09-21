ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :has_many => :builds
  map.root :controller => "projects"
end

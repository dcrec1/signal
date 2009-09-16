# Create an application controller to satisfy rspec-rails, a dummy controller
# and define routes.
#
class ApplicationController < ActionController::Base
end

class Task; end

# Define routes
ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :has_many => :tasks
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end


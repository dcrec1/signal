class BuildsController < InheritedResources::Base
  belongs_to :project

  caches_page :show
end

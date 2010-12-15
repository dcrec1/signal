SignalCI::Application.routes.draw do
  resources :projects do
    resources :builds
    resources :deploys
    collection do
      match 'build' => "projects#build"
      match 'status' => "projects#fetch_status"
    end
  end
  root :to => "projects#index"
  match "/projects/:name/tmp/metric_fu/output/index.html" => "static#content", :as => 'metrics'
  match "/projects/:name/doc/specs.html" => "static#content", :as => 'specs'
  match "/projects/:name/doc/features.html" => "static#content", :as => 'features'
  match "/projects/:name/target/:name.war" => "static#content", :as => 'war'
end

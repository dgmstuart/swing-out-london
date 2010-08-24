ActionController::Routing::Routes.draw do |map|
  map.resources :organisers, :has_many => :events

  map.resources :venues, :has_many => :events

  map.resources :events
  
  map.root :controller => "website"

  map.connect 'admin/', :controller => 'events'
  map.connect ':action/', :controller => 'website'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

Swingoutlondon::Application.routes.draw do

  root :to => 'website#index'

  resources :organisers do
    resources :events
  end

  resources :venues do
    resources :events
  end

  resources :events do
    put :archive, :on => :member
    collection do
      resources :imports, only: [:new, :create], as: "events_imports", :controller => "events/imports" do
        collection { post 'save' }
      end
    end
  end

  match 'map/classes/(:day)/(:id)' => 'maps#classes'
  match 'map/socials/(:date)/(:id)' => 'maps#socials'
  match 'map' => 'maps#socials'
  match 'venue_map_info/:id' => 'maps#venue_map_info', :as => :venue_map_info

  match 'name_clash' => 'name_clash#index'
  match 'outdated' => 'outdated#index'

  match 'latest_tweet' => 'website#latest_tweet'
  match 'about' => 'website#about'
  match 'listings_policy' => 'website#listings_policy'
end

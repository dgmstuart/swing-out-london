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

  match 'map/classes/(:day)' => 'maps#classes', as: :map_classes
  match 'map/socials/(:date)' => 'maps#socials', as: :map_socials
  match 'map' => 'maps#socials'
  match 'venue_map_info/:id' => 'maps#venue_map_info', :as => :venue_map_info

  match 'name_clash' => 'name_clash#index'
  match 'outdated' => 'outdated#index'

  match 'latest_tweet' => 'website#latest_tweet'
  match 'about' => 'website#about'
  match 'listings_policy' => 'website#listings_policy'

  match 'apple-touch-icon-precomposed' => 'application#not_found'
  match 'apple-touch-icon-(:size)-precomposed' => 'application#not_found'
  match 'apple-app-site-association' => 'application#not_found'
end

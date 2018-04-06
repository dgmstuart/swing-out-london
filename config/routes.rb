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

  get 'map/classes/(:day)' => 'maps#classes', as: :map_classes
  get 'map/socials/(:date)' => 'maps#socials', as: :map_socials
  get 'map' => 'maps#socials'
  get 'venue_map_info/:id' => 'maps#venue_map_info', :as => :venue_map_info

  # legacy routes:
  get 'map/classes/:day/:venue_id', to: redirect('/map/classes/%{day}?venue_id=%{venue_id}')
  get 'map/socials/:date/:venue_id', to: redirect('/map/socials/%{date}?venue_id=%{venue_id}')

  get 'name_clash' => 'name_clash#index'
  get 'outdated' => 'outdated#index'

  get 'about' => 'website#about'
  get 'listings_policy' => 'website#listings_policy'

  get 'apple-touch-icon-precomposed' => 'application#not_found'
  get 'apple-touch-icon-(:size)-precomposed' => 'application#not_found'
  get 'apple-app-site-association' => 'application#not_found'
end

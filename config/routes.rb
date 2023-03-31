# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "listings#index"

  resources :organisers do
    resources :events
  end

  resources :venues do
    resources :events
  end

  resources :events do
    put :archive, on: :member
    resources :organiser_tokens, only: %i[create]
  end

  resources :external_events, only: %i[edit update]

  get "map/classes/(:day)" => "maps#classes", as: :map_classes
  get "map/socials/(:date)" => "maps#socials", as: :map_socials
  get "map" => "maps#socials"
  get "venue_map_info/:id" => "maps#venue_map_info", :as => :venue_map_info

  get "name_clash" => "name_clash#index"
  get "outdated" => "outdated#index"

  get "about" => "info#about"
  get "listings_policy" => "info#listings_policy"
  get "privacy" => "info#privacy"

  get "login" => "sessions#new"
  get "auth/facebook/callback" => "sessions#create"
  get "auth/failure" => "sessions#failure"
  delete "logout" => "sessions#destroy", as: "logout"

  resource :account, only: %i[show destroy], controller: :users

  resource :audit_log, only: %i[show]

  get "apple-touch-icon-precomposed" => "application#not_found"
  get "apple-touch-icon-(:size)-precomposed" => "application#not_found"
  get "apple-app-site-association" => "application#not_found"
end

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
    resource :organiser_link, only: %i[create]
  end

  resources :external_events, only: %i[edit update]

  get "map/classes/(:day)" => "maps#classes", as: :map_classes
  get "map/socials/(:date)" => "maps#socials", as: :map_socials
  get "map" => "maps#socials"
  get "venue_map_info/:id" => "maps#venue_map_info", :as => :venue_map_info
  get "occasional" => "occasional_events#index"

  get "name_clash" => "name_clash#index"

  get "about" => "info#about"
  get "listings_policy" => "info#listings_policy"
  get "privacy" => "info#privacy"

  get "login" => "sessions#new"
  get "auth/facebook/callback" => "sessions#create"
  get "auth/failure" => "sessions#failure"
  delete "logout" => "sessions#destroy", as: "logout"

  put "facebook_access_token" => "facebook_access_tokens#refresh", as: "facebook_access_token"

  resource :account, only: %i[show destroy], controller: :users

  namespace :admin do
    resources :users, only: %i[index destroy]
    resource :audit_log, only: %i[show]
    resource :cache, only: %i[show destroy]
  end

  resource :audit_log, only: %i[show]

  get "robots.txt", to: "robots#index", format: "txt"
  get "sitemap", to: "sitemaps#index", defaults: { format: "xml" }
  get "sitemap_index.xml", to: redirect("/sitemap.xml"), status: 301
  get "sitemap.xml.gz", to: redirect("/sitemap.xml"), status: 301
  get "sitemaps.xml", to: redirect("/sitemap.xml"), status: 301

  get "apple-touch-icon-precomposed" => "application#not_found"
  get "apple-touch-icon-:size-precomposed" => "application#not_found"
  get "apple-app-site-association" => "application#not_found"
  get "swingoutlondon_og.png" => redirect(ActionController::Base.helpers.image_path(CITY.opengraph_image))
  get ".well-known" => "robots#no_content"
  get ".well-known/apple-app-site-association" => "robots#empty_json"
  get ".well-known/traffic-advice" => "robots#no_content"
  get ".well-known/pki-validation" => "robots#no_content"
end

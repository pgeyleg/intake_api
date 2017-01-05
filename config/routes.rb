# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :participants, only: [:create]
      resources :people
      resources :people_search, only: [:index]
      resources :screenings
    end
  end
end

# frozen_string_literal: true

# app/config/routes.rb
Rails.application.routes.draw do
  concern :base_api do
    get '/country_guess', to: 'countries#guess'
  end

  namespace :v1, defaults: { format: :json } do
    concerns :base_api
  end
end

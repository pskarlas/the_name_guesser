# frozen_string_literal: true

# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  # For simplicity reasons no User model was created with an api_token attribute
  # A bare simple string is used and saved in Rails credentials mocking up a user based
  # generated JWT that is usually stored in DB
  def client_has_valid_token?
    request.headers["Authorization"] == Rails.application.credentials.guessing_access_token
  end

  def authenticate_request
    render json: { error: 'Unauthorized' }, status: :unauthorized unless client_has_valid_token?
  end
end

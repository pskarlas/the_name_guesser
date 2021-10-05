# frozen_string_literal: true

# app/controllers/V1/countries_controller.rb
class V1::CountriesController < ApplicationController

  before_action :set_name, :set_cache_key

  def guess
    start = starting_execution
    # Give feedback on bad input early
    return bad_request_for(@person_name) unless valid_name?(@person_name)
    # Check cache
    guessed_country = Rails.cache.fetch(@cache_key, expires_in: 24.hours) do
      NamsorServices::DetermineCountryFromSurname.new(@person_name).call
    end

    if guessed_country.success?
      render json: {
        guessed_country: guessed_country.payload,
        requested_name: @person_name,
        time_processed: elapsed_from(start)
      }, status: :ok
    else
      render json: { error: 'We could not process your request this time' },
        status: :bad_gateway
    end
  end

  private

  def set_name
    @person_name = params[:name]
  end

  def set_cache_key
    @cache_key = ["country_guess", @person_name]
  end

  def bad_request_for(name)
    render json: { error: 'A valid name parameter is required.
                    Name should be present and consisted by letters only'.squish
                  }, status: :bad_request
  end

  def valid_name?(name)
    return false if name.nil?
    name[/[[:alpha:]]+/] == name ? true : false
  end

  def starting_execution
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def elapsed_from(start)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    (ending - start).round(3)
  end

end

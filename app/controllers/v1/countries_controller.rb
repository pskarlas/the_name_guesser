# frozen_string_literal: true

# app/controllers/V1/countries_controller.rb
class V1::CountriesController < ApplicationController

  def guess
    start = starting_execution
    person_name = params[:name]

    # Return early and give feedback for clients bad request
    return bad_request_for(person_name) unless valid_name?(person_name)

    guessed_country = NamsorServices::DetermineCountryFromSurname.new(person_name).call

    if guessed_country.success?
      render json: {
        guessed_country: guessed_country.payload,
        requested_name: person_name,
        time_processed: elapsed_from(start)
      }, status: :ok
    else
      render json: { error: 'We could not process your request this time' },
        status: :bad_gateway
    end
  end

  private

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

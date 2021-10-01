# frozen_string_literal: true

# app/controllers/V1/countries_controller.rb
class V1::CountriesController < ApplicationController

  def guess
    start = starting_execution
    name = params[:name]
    guessed_country = NamsorServices::GuessCountryFromName.new(name).call
    if guessed_country.success?
      render json: {
        guessed_country: guessed_country.payload,
        requested_name: name,
        time_processed: elapsed_from(start)
      }
    else
      render json: { status: :unprocessable_entity }
    end
  end

  private

  def starting_execution
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def elapsed_from(start)
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    (ending - start).round(3)
  end
end

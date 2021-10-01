# frozen_string_literal: true

# app/services/namsor_services/guess_country_from_name.rb
# NamSor API v2.0.16
module NamsorServices
  require 'net/http'
  class GuessCountryFromName

    ACCESS_TOKEN = Rails.application.credentials.namsor_access_token

    def initialize(name)
      @name = name
      @uri = URI('https://v2.namsor.com/NamSorAPIv2/api2/json/country/' + @name.to_s)
    end

    def call
      response = Net::HTTP.start(@uri.host, @uri.port,
        use_ssl:  @uri.scheme == 'https', max_retries: 3) do |http|
        req = Net::HTTP::Get.new @uri
        req['x-api-key'] = "#{ACCESS_TOKEN}"
        res = http.request req
      end

      if response.is_a?(Net::HTTPSuccess)
        result = JSON.parse response.body
        OpenStruct.new(success?: true, payload: result["country"])
      else
        OpenStruct.new(success?: false, payload: response.body)
      end
    end
  end
end

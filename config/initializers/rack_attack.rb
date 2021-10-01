# frozen_string_literal: true

# config/initializers/rack_attack.rb
class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle('API/ip', limit: 1, period: 2.seconds ) do |req|
    req.ip
  end
end

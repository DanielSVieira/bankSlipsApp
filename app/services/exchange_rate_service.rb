# app/services/exchange_rate_service.rb
require "faraday"
require "faraday_middleware"

class ExchangeRateService
  # Configurable base URL
  DEFAULT_BASE_URL = "http://localhost:3001/"

  def initialize(base_url = DEFAULT_BASE_URL)
    @base_url = base_url
    @connection = Faraday.new(url: @base_url) do |faraday|
      faraday.response :json, parser_options: { symbolize_names: true } # auto JSON parse
      faraday.adapter Faraday.default_adapter
    end
  end

  # Fetch exchange rates for a given base currency
  # Example: fetch("USD")
  def fetch(from_currency)
    response = @connection.get("api/exchange_rates", { from: from_currency })

    unless response.success?
      raise "Error fetching exchange rates: #{response.status}"
    end

    ExchangeRateDTO.new(response.body)
  end
end

# app/dtos/exchange_rate_dto.rb
class ExchangeRateDTO
  attr_reader :rate

  attr_reader :brl_rate

  # data: parsed JSON with symbolized keys
  def initialize(data)
    # Find the rate to BRL
    brl = data[:rates].find { |r| r[:to] == "BRL" }
    @brl_rate = brl ? brl[:rate] : 0
  end

  # simple accessor
  def rate
    brl_rate
  end

  def amount
    @rate
  end
end

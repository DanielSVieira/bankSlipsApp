# app/dtos/exchange_rate_dto.rb
class ExchangeRateDTO
  attr_reader :from, :rates

  def initialize(data)
    @from = data[:from]
    @rates = data[:rates] || []
  end

  def rate_for(to_currency)
    rate_entry = @rates.find { |r| r[:to] == to_currency }
    rate_entry ? rate_entry[:rate] : 0
  end

  def rate
    rate_for("BRL")
  end

  def amount
    rate
  end
end

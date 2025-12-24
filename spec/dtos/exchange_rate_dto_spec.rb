# spec/services/exchange_rate_dto_spec.rb
require "rails_helper"

RSpec.describe ExchangeRateDTO do
  describe "#rate" do
    context "when BRL rate exists" do
      let(:data) do
        {
          from: "USD",
          rates: [
            { from: "USD", to: "EUR", rate: 0.85 },
            { from: "USD", to: "BRL", rate: 5.52 },
          ],
        }
      end

      it "returns the BRL rate" do
        dto = ExchangeRateDTO.new(data)
        expect(dto.rate).to eq(5.52)
      end
    end

    context "when BRL rate does NOT exist" do
      let(:data) do
        {
          from: "USD",
          rates: [
            { from: "USD", to: "EUR", rate: 0.85 },
          ],
        }
      end

      it "returns 0" do
        dto = ExchangeRateDTO.new(data)
        expect(dto.rate).to eq(0)
      end
    end
  end
end

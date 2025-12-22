# spec/requests/api/v1/bank_slips_spec.rb
require "rails_helper"

RSpec.describe "Api::V1::BankSlips", type: :request do
  describe "POST /api/v1/bank_slips" do
    let(:valid_params) do
      {
        bank_slip: {
          customer: "John Doe",
          total_in_cents: 1000,
          due_date: "2025-12-31",
          status: "pending",
          external_id: "unique-id-123",
        },
      }
    end

    it "creates a new bank slip" do
      # 1. Perform the action
      post "/api/v1/bank_slips", params: valid_params

      # 2. If it fails, print the errors so we can see WHY
      if response.status != 201
        puts "\n--- TEST FAILED ---"
        puts "Response Body: #{response.body}"
        puts "-------------------\n"
      end

      # 3. Assertions
      expect(response).to have_http_status(:created)
      expect(BankSlip.count).to eq(1)
    end
  end
end

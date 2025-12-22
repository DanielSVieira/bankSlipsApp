# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # method to generate a bank slip with default valid attributes
  def generate_bank_slip(overrides = {})
    # Default valid attributes
    defaults = {
      customer: "Default Customer",
      total_in_cents: 1000,
      due_date: Date.tomorrow,
      external_id: "EXT-#{SecureRandom.hex(4)}", # Generates random ID like EXT-a1b2c3d4
      status: :pending,
    }

    # Merge defaults with any overrides provided
    attributes = defaults.merge(overrides)

    # We use 'new' instead of 'create' so we can decide whether to save or not
    bank_slip = BankSlip.new(attributes)
    bank_slip.save if attributes[:save] != false
    bank_slip
  end
end

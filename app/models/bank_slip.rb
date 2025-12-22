class BankSlip < ApplicationRecord
  #1. Validations (The following fields are required on the API / UI)
  validates :due_date, :total_in_cents, :customer, presence: true

  #Field total_in_cents must be a positive number
  validates :total_in_cents, numericality: { greater_than: 0 }

  # Ensure external_id is unique
  validates :external_id, uniqueness: true

  #allow it to be blank on the API, with a default value
  enum :status, { pending: "pending", paid: "paid", canceled: "canceled" }, default: :pending

  # 2. Logic
  def total_amount
    total_in_cents / 100.0
  end

  # Custom transition methods with guards
  def transition_to_paid!
    raise "Only pending slips can be paid" unless pending?

    update!(status: :paid)
  rescue ActiveRecord::StaleObjectError
    errors.add(:base, "This record was updated by another user. Please refresh the page.")
    false
  end

  def transition_to_canceled!
    raise "Only pending slips can be canceled" unless pending?

    update!(status: :canceled)
  rescue ActiveRecord::StaleObjectError
    errors.add(:base, "This record was updated by another user. Please refresh the page.")
    false
  end
end

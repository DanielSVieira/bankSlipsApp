require "test_helper"

class BankSlipTest < ActiveSupport::TestCase
  setup do
    @bank_slip = generate_bank_slip
  end

  test "should transition from pending to paid" do
    slip = generate_bank_slip
    assert slip.transition_to_paid!
    assert_equal "paid", slip.status
  end

  test "should disallow paying a canceled slip" do
    slip = generate_bank_slip(status: :canceled)

    assert_raises(RuntimeError, "Only pending slips can be paid") do
      slip.transition_to_paid!
    end
  end

  test "optimistic locking prevents simultaneous updates" do
    slip1 = BankSlip.find(@bank_slip.id)
    slip2 = BankSlip.find(@bank_slip.id)

    slip1.update!(customer: "New Name")

    # slip2 still has the old lock_version in memory
    assert_raises(ActiveRecord::StaleObjectError) do
      slip2.update!(customer: "Different Name")
    end
  end
end

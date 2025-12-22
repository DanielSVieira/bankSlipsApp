require "test_helper"

class BankSlipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bank_slip = generate_bank_slip
  end

  test "should get index" do
    get bank_slips_url
    assert_response :success
    assert_select "h1", "Bank Slips Management"
  end

  test "should create bank_slip via turbo stream" do
    assert_difference("BankSlip.count") do
      post bank_slips_url, params: {
                             bank_slip: {
                               customer: "New Customer",
                               total_in_cents: 2000,
                               due_date: Date.today,
                               external_id: "UNIQUE-001",
                             },
                           }, as: :turbo_stream
    end

    assert_response :success
    # Check if the response contains the turbo-stream action to prepend
    assert_match /turbo-stream action="prepend" target="bank-slips-list"/, response.body
  end

  test "should pay bank_slip" do
    patch pay_bank_slip_url(@bank_slip), as: :turbo_stream

    @bank_slip.reload
    assert_equal "paid", @bank_slip.status
    assert_response :success
  end
end

# app/controllers/bank_slips_controller.rb
require_relative "../dtos/exchange_rate_dto"

class BankSlipsController < ApplicationController
  def base_url
    ExchangeRateService::DEFAULT_BASE_URL
  end

  def index
    @bank_slips = BankSlip.order(created_at: :desc)

    @bank_slip = BankSlip.new
  end

  def create
    @bank_slip = BankSlip.new(bank_slip_params)

    respond_to do |format|
      if @bank_slip.save
        format.turbo_stream # This will look for create.turbo_stream.erb
        format.html { redirect_to bank_slips_path, notice: "Created!" }
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def details
    @bank_slip = BankSlip.find(params[:id])

    # calculate fine if pending
    if @bank_slip.pending?
      begin
        response = Faraday.get("#{base_url}/api/exchange_rates", { from: "EUR" })
        @fine = 0

        if response.success?
          data = JSON.parse(response.body, symbolize_names: true)
          exchange_rate_dto = ExchangeRateDTO.new(data)
          latest_rate = exchange_rate_dto.rate
          @fine = (@bank_slip.total_amount / 100.0) * latest_rate
        end
      rescue => e
        Rails.logger.error "Failed to fetch exchange rate: #{e.message}"
        @fine = nil
      end
    end

    render partial: "bank_slips/details", locals: { bank_slip: @bank_slip, fine: @fine }
  end

  def bank_slip_params
    params.require(:bank_slip).permit(:customer, :total_in_cents, :due_date, :external_id)
  end

  before_action :set_bank_slip, only: [:pay, :cancel]

  def pay
    begin
      if @bank_slip.transition_to_paid!
        render_update
      else
        render_error("Could not process payment.")
      end
    rescue => e
      render_error(e.message)
    end
  end

  def cancel
    begin
      if @bank_slip.transition_to_canceled!
        render_update
      else
        render_error("Could not cancel slip.")
      end
    rescue => e
      render_error(e.message)
    end
  end

  private

  def set_bank_slip
    @bank_slip = BankSlip.find(params[:id])
  end

  def render_update
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@bank_slip) }
      format.html { redirect_to root_path }
    end
  end

  def render_error(message)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.prepend("bank-slips-list", partial: "shared/error", locals: { message: message }) }
      format.html { redirect_to root_path, alert: message }
    end
  end
end

# app/controllers/bank_slips_controller.rb
class BankSlipsController < ApplicationController
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

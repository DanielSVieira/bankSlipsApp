# app/controllers/api/v1/bank_slips_controller.rb
module Api
  module V1
    class BankSlipsController < ActionController::API
      def index
        @bank_slips = BankSlip.all
        render json: BankSlipBlueprint.render(@bank_slips)
      end

      def create
        @bank_slip = BankSlip.new(bank_slip_params)
        if @bank_slip.save
          render json: BankSlipBlueprint.render(@bank_slip), status: :created
        else
          render json: { errors: @bank_slip.errors }, status: :unprocessable_entity
        end
      end

      def show
        @bank_slip = BankSlip.find(params[:id])
        render json: BankSlipBlueprint.render(@bank_slip)
      end

      private

      def bank_slip_params
        params.require(:bank_slip).permit(:due_date, :total_in_cents, :customer, :external_id)
      end
    end
  end
end

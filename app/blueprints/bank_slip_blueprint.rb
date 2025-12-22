class BankSlipBlueprint < Blueprinter::Base
  identifier :id
  fields :customer, :total_in_cents, :due_date, :status, :external_id
end

class CreateBankSlips < ActiveRecord::Migration[8.1]
  def change
    create_table :bank_slips do |t|
      t.date :due_date, null: false
      t.decimal :total_in_cents, null: false
      t.string :customer, null: false

      # Optional field with a default value
      t.string :status, null: false, default: "pending"
      t.string :external_id, null: false, index: { unique: true }
      t.datetime :paid_at

      t.timestamps
    end
  end
end

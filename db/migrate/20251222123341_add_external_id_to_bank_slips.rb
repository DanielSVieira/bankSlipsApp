class AddExternalIdToBankSlips < ActiveRecord::Migration[8.1]
  def change
    add_column :bank_slips, :external_id, :string
    add_index :bank_slips, :external_id
  end
end

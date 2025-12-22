class AddLockVersionToBankSlips < ActiveRecord::Migration[8.1]
  def change
    add_column :bank_slips, :lock_version, :integer
  end
end

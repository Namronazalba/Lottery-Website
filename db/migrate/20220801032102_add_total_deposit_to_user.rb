class AddTotalDepositToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :total_deposit, :decimal
  end
end

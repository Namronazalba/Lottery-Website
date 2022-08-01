class AddCoinsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :coins, :int
  end
end

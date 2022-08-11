class AddParentIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :parent_id, :int
  end
end

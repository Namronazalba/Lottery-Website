class AddChildrenMembersToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :children_members, :int
  end
end

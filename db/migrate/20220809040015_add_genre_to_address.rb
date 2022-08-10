class AddGenreToAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :genre, :integer
  end
end

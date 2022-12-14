class Category < ApplicationRecord
  validates_presence_of :name
  has_many :items

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end

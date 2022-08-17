class Barangay < ApplicationRecord
  validates :code, :name, presence: true
  validates_presence_of
  belongs_to :city
end

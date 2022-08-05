class City < ApplicationRecord
  validates_presence_of :code
  validates_presence_of :name
  belongs_to :district
  has_many :barangays
end

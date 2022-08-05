class Barangay < ApplicationRecord
  validates_presence_of :code
  validates_presence_of :name
  belongs_to :municipality,optional:true
  belongs_to :city,optional:true
end

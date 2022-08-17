class Province < ApplicationRecord
  validates :code,:name, presence: true
  belongs_to :region
  has_many :city_municipalities
end

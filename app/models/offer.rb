class Offer < ApplicationRecord
  validates :image, :name, :genre, :status, :amount, :coin, presence: true
  enum genre: [:one_time, :monthly, :weekly, :daily, :regular]
  enum status: [:active, :inactive]
  mount_uploader :image, ImageUploader
end

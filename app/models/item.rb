class Item < ApplicationRecord
  belongs_to :category
  has_many :bets
  validates :image, :name, :quantity, :minimum_bet, :batch_count, :online_at, :offline_at, :start_at, :status, presence: true
  scope :filter_by_category, -> (category) { includes(:category).where(category: {name: category}) }

  enum status: [:active, :inactive]

  mount_uploader :image, ImageUploader

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :change_status, guards: [ :less_than_one?, :offline_time?, :active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def change_status
    self.update(quantity: self.quantity - 1, batch_count: self.batch_count + 1)
  end

  def less_than_one?
    quantity >= 0
  end

  def offline_time?
    offline_at > Time.now
  end
end

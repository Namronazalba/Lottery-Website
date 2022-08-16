class Item < ApplicationRecord
  belongs_to :category
  validates_presence_of :name
  validates_presence_of :quantity
  validates_presence_of :minimum_bet
  scope :filter_by_category, -> (category) { includes(:category).where(category: {name: category}) }

  mount_uploader :image, ImageUploader

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start, after: :change_status do
      transitions from: [:pending, :ended, :cancelled, :paused], to: :starting, guards: [:set_process, :less_than_one?, :offline_time?, :is_active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from [:starting, :paused], to: :cancelled
    end
  end

  def change_status
    self.update(quantity: self.quantity - 1, batch_count: self.batch_count + 1)
  end

  def less_than_one?
    quantity > 0
  end

  def offline_time?
    offline_at > Time.now
  end

  def is_active?
    status == "Active"
  end


end

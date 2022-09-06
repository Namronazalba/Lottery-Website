class Item < ApplicationRecord
  belongs_to :category
  has_many :bets
  validates :image, :name, :quantity, :minimum_bet, :batch_count, :online_at, :offline_at, :start_at, :status, presence: true
  scope :filter_by_category, -> (category) { includes(:category).where(category: {name: category}) }
  validates :quantity, :minimum_bet, numericality: { greater_than: 0 }

  enum status: [:active, :inactive]

  mount_uploader :image, ImageUploader

  default_scope { where(deleted_at: nil) }

  def destroy
    if bets.blank?
      update(deleted_at: Time.current)
    end
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :start_batch, guards: [:quantity_at_least_one?, :greater_than_time_now?, :status_active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended,after: :select_random_winner, guards: :at_least_minimum_bet?
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled, after: [:item_cancel, :cancel_bet]
    end
  end


  def start_batch
    self.update(quantity: self.quantity - 1, batch_count: self.batch_count + 1)
  end

  def quantity_at_least_one?
    quantity >= 0
  end

  def greater_than_time_now?
    offline_at > Time.now
  end

  def at_least_minimum_bet?
    bets.active_bets(batch_count).count >= minimum_bet
  end

  def status_active?
    return true if self.status == 'active'
    errors.add(:base, 'The item is inactive')
    false
  end

  def item_cancel
    self.update(quantity: self.quantity + 1)
  end

  def cancel_bet
    bets.where(batch_count: batch_count).where.not(state: :cancelled).each { |bet| bet.cancel! }
  end


  def select_random_winner
    select_state_betting = bets.active_bets(batch_count)
    find_random_winner = select_state_betting.sample
    find_random_winner.win!
    select_state_betting.where.not(id: find_random_winner.id).each { |bet| bet.lose!}
    winner = Winner.new( user: find_random_winner.user, bet: find_random_winner, item: find_random_winner.item, item_batch_count: find_random_winner.batch_count)
    winner.save!
  end
end

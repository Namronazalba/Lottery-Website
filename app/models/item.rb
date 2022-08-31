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
    update(deleted_at: Time.current)
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :change_status, guards: [:less_than_one?, :offline_time?, :active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: [:starting, :paused], to: :ended,after: :select_winner,guards: :min_bet?
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled, after: [:if_cancel?, :return_coin]
    end
  end

  def select_winner
    select_one = bets.where(batch_count: batch_count).where.not(state: :cancelled)
    selected_winner = select_one.sample
    selected_winner.win!
    select_one.where.not(id: selected_winner.id).update_all(state: :lost)

    winner = Winner.new( user: selected_winner.user, bet: selected_winner, item: selected_winner.item, item_batch_count: selected_winner.batch_count, address: selected_winner.user.addresses.find_by(is_default: true))
    winner.save!
  end

  def return_coin
    self.update(quantity: self.quantity + 1, batch_count: self.batch_count - 1)
  end

  def change_status
    self.update(quantity: self.quantity - 1, batch_count: self.batch_count + 1)
  end

  def if_cancel?
    bets.where(batch_count: batch_count).where.not(state: :cancelled).each { |bet| bet.cancel! }
  end

  def less_than_one?
    quantity >= 0
  end

  def offline_time?
    offline_at > Time.now
  end

  def min_bet?
    bets.where(batch_count: batch_count).count >= minimum_bet
  end

  def pick_winner

  end
end
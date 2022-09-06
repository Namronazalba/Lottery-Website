class Order < ApplicationRecord
  belongs_to :user
  belongs_to :offer, optional: true
  validates :amount, :coin, presence: true

  validates :amount, numericality: { greater_than: 0 }, if: :deposit?
  validates :amount, numericality: { greater_than_or_equal: 0 }, unless: :deposit?
  enum genre: [:deposit, :increase, :deduct, :bonus, :share]

  after_create :generate_serial_number

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, after: :cancel_update_user_coin, guard: :coin_less_that_user_coins?
    end

    event :pay do
      transitions from: :submitted, to: :paid, after: :update_user_coin_on_pay
    end
  end

  def cancel_update_user_coin
    if deduct?
      user.update(coins: user.coins + coin)
    else
      user.update(coins: user.coins - coin)
    end
  end

  def coin_less_that_user_coins?
    return true if (user.coins >= coin) && !deduct?
    errors.add(:base, "You deducted more coins than the user's total coins")
    false
  end

  def update_user_coin_on_pay
    if deduct?
      user.update(coins: user.coins - coin)
    else
      user.update(coins: user.coins + coin)
    end
  end

  def deduct
    return true if (user.coins > coin) && !deduct?
    errors.add(:base, "You deducted too much coins")
    false
  end

  def generate_serial_number
    ActiveRecord::Base.connection.execute("UPDATE `orders` SET `orders`.`serial_number` = CONCAT(DATE_FORMAT(CONVERT_TZ(orders.created_at, '+00:00', '+8:00'), '%y%m%d'),'-',#{id},'-',#{user.id},'-',
                                                    (SELECT LPAD(count(*), 4, 0)
                                                     FROM `orders` where `orders`.`user_id` = #{user.id}))
                                                     WHERE orders.id = #{id}")
  end
end

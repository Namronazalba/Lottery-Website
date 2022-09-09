class Order < ApplicationRecord
  belongs_to :user
  belongs_to :offer, optional: true
  validates :amount, :coin, presence: true

  enum genre: [:deposit, :increase, :deduct, :bonus, :share]

  validates :amount, numericality: { greater_than: 0 }, if: :deposit?
  validates :amount, numericality: { greater_than_or_equal: 0 }, unless: :deposit?


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
      transitions from: :paid, to: :cancelled, after: :cancel_user_coin, guard: :coin_less_that_user_coins?
    end

    event :pay, after: :update_user_coin_on_pay do
      transitions from: :submitted, to: :paid
      transitions from: :pending, to: :paid, guard: :unless_coin_less_that_user_coins?
    end
  end

  def cancel_user_coin
    if deduct?
      user.update(coins: user.coins +  coin)
    else
      user.update(coins: user.coins - coin)
    end
  end

  def update_user_coin_on_pay
    if deduct?
      user.update(coins: user.coins - coin)
    else
      user.update(coins: user.coins + coin)
    end
  end

  def coin_less_that_user_coins?
    return true if deduct?
    return true if (user.coins >= coin)
    errors.add(:base, "You deducted more coins than the user's total coins")
    false
  end

  def unless_coin_less_that_user_coins?
    return true unless deduct?
    return true if (user.coins >= coin)
    errors.add(:base, "Unless you deducted more coins than the user's total coins")
    false
  end

  def generate_serial_number
    ActiveRecord::Base.connection.execute("UPDATE `orders` SET `orders`.`serial_number` = CONCAT(DATE_FORMAT(CONVERT_TZ(orders.created_at, '+00:00', '+8:00'), '%y%m%d'),'-',#{id},'-',#{user.id},'-',
                                                    (SELECT LPAD(count(*), 4, 0)
                                                     FROM `orders` where `orders`.`user_id` = #{user.id}))
                                                     WHERE orders.id = #{id}")
  end
end

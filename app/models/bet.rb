class Bet < ApplicationRecord
  belongs_to :item
  belongs_to :user
  validates :coins , :batch_count, presence: true
  validates :coins, numericality: { greater_than: 0 }
  after_commit :generate_serialnumber

  include AASM
  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :betting, to: :won
    end
    event :lose do
      transitions from: :betting, to: :lost
    end

    event :cancel do
      transitions from: :betting, to: :cancelled
    end
  end

  def generate_serialnumber
    ActiveRecord::Base.connection.execute("UPDATE `bets` SET `bets`.`serial_number` = CONCAT(DATE_FORMAT(CONVERT_TZ(bets.created_at, '+00:00', '+8:00'), '%y%m%d'),'-',#{item.id},'-',#{item.batch_count},'-',
                                                  (SELECT LPAD(count(*), 4, 0)
                                                   FROM `bets` where `bets`.`id` <= #{id} and DATE(CONVERT_TZ(bets.created_at, '+00:00', '+8:00')) = (select DATE(CONVERT_TZ(bets.created_at, '+00:00', '+8:00'))
                                                   FROM bets WHERE bets.id = #{id})))
                                                   WHERE bets.id = #{id}")
  end
end

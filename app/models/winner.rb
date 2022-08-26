class Winner < ApplicationRecord
  belongs_to :item, optional: true
  belongs_to :bet, optional: true
  belongs_to :user, optional: true
  belongs_to :address, optional: true
  after_commit :generate_serialnumber

  include AASM
  aasm column: :state do
    state :betting, initial: true
    state :won, :claimed, :submitted, :paid, :shipped, :delivered, :shared, :published, :remove_published

    event :claim do
      transitions from: :won, to: :claimed
    end

    event :submit do
      transitions from: :claimed, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :share do
      transitions from: :delivered, to: :shared
    end

    event :publish do
      transitions from: [:shared, :remove_published], to: :published
    end

    event :remove_publish do
      transitions from: :published, to: :remove_published
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

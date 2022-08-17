class Address < ApplicationRecord
  validates :name, :street_address, :phone_number,:remark, presence: true
  validates_presence_of :is_default, allow_blank: true

  belongs_to :region
  belongs_to :province
  belongs_to :city
  belongs_to :barangay
  belongs_to :user

  before_create :default
  before_destroy :remove_nodefault
  after_commit :default_address

  validate :five_only, on: :create
  enum genre: [:home, :office]

  #Save only one default address
  def default
    unless self.user.addresses.present?
      self.is_default = true
    end
  end
  def remove_nodefault
    if is_default
      throw(:abort)
    end
  end
  def default_address
    if is_default
      self.user.addresses.where("id != ?", self.id).update_all(is_default: false)
    end
  end

  #Count user address
  def five_only
    return unless self.user
    if self.user.addresses.count >= 5
      errors.add(:base, "You reached the maximum number of address")
    end
  end
  # def limit_address
  #   return unless self.user
  #   if self.user.addresses.reload.count >= 5
  #     errors.add(:base, "You reach the limit")
  #   end
  # end
end
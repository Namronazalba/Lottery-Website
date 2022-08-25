class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  belongs_to :parent, class_name: "User", optional: true, counter_cache: :children_members
  has_many :children, class_name: "User", foreign_key: 'parent_id'
  has_many :bets

  validates :phone, phone: {allow_blank: true}
  has_many :addresses

  mount_uploader :avatar, AvatarUploader

  def client?
    role == 'client'
  end

  def admin?
    role == 'admin'
  end
end

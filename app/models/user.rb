class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  belongs_to :parent, class_name: "User", optional: true, counter_cache: :children_members
  has_many :children, class_name: "User", foreign_key: 'parent_id'
  has_many :bets
  has_many :orders
  has_many :winners
  has_many :addresses
  has_many :newstickers, foreign_key: "admin_id"
  validates :phone, phone: {allow_blank: true}


  mount_uploader :avatar, AvatarUploader

  def client?
    role == 'client'
  end

  def admin?
    role == 'admin'
  end
end

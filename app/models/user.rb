class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  validates :phone, phone: {allow_blank: true}

  mount_uploader :avatar, AvatarUploader

  def client?
    role == 'client'
  end

  def admin?
    role == 'admin'
  end

end

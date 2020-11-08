class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :avatar, ImageUploader

  has_many :comments
  has_many :likes

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: "を○○@○○.○○の形式で入力して下さい" }, length: { maximum: 255 }
  validates :nickname, presence: true, length: { in: 2..20 }
  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*\d)[a-z\d]{8,}+\z/
  validates :password, length: { maximum: 75 }, format: { with: VALID_PASSWORD_REGEX, message: "を半角英数字8文字以上で入力して下さい" }, on: :create
end

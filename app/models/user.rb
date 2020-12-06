class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :avatar, ImageUploader

  has_many :comments
  has_many :likes
  has_many :messages
  has_many :entries
  has_many :rooms, through: :entries
  has_many :requests
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id'
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id'
  has_many :sold_tickets, class_name: "Ticket", foreign_key: 'seller_id', dependent: :destroy
  has_many :buyed_tickets, class_name: "Ticket", foreign_key: 'buyer_id'

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: "を○○@○○.○○の形式で入力して下さい" }, length: { maximum: 255 }
  validates :nickname, presence: true, length: { maximum: 15 }
  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*\d)[a-z\d]{8,}+\z/
  validates :password, length: { maximum: 75 }, format: { with: VALID_PASSWORD_REGEX, message: "を半角英数字8文字以上で入力して下さい" }, on: :create

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = "password0"
      user.nickname = "ゲストユーザ"
    end
  end

end

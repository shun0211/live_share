# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :avatar, ImageUploader

  has_many :comments, dependent: :nullify
  has_many :likes, dependent: :nullify
  has_many :messages, dependent: :nullify
  has_many :entries, dependent: :nullify
  has_many :rooms, through: :entries
  has_many :requests, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy, inverse_of: 'visitor'
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy, inverse_of: 'visited'
  has_many :sold_tickets, class_name: 'Ticket', foreign_key: 'seller_id', dependent: :destroy, inverse_of: 'seller'
  has_many :buyed_tickets, class_name: 'Ticket', foreign_key: 'buyer_id', dependent: :nullify, inverse_of: 'buyer'
  has_many :cards, dependent: :destroy
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: 'を○○@○○.○○の形式で入力して下さい' }, length: { maximum: 255 }
  validates :nickname, presence: true, length: { maximum: 15 }
  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*\d)[a-z\d]{8,}+\z/.freeze
  validates :password, length: { maximum: 75 }, format: { with: VALID_PASSWORD_REGEX, message: 'を半角英数字8文字以上で入力して下さい' }, on: :create

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = 'password0'
      user.nickname = 'ゲストユーザ'
    end
  end

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
end

# frozen_string_literal: true

class Ticket < ApplicationRecord
  mount_uploader :thumbnail, ImageUploader
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :notifications, dependent: :destroy
  belongs_to :seller, class_name: 'User'
  belongs_to :buyer, class_name: 'User', optional: true

  def liked_by(user)
    likes.where(user_id: user.id).exists?
  end

  def create_notification_like(current_user)
    # すでに「通知」がされているか検索
    like_notification = Notification.where('visitor_id = ? and visited_id = ? and ticket_id = ? and action = ?', current_user.id, seller_id, id, 'like')
    if like_notification.blank? && !(current_user.id == seller_id)
      notification = Notification.new(
        visitor_id: current_user.id,
        visited_id: seller_id,
        ticket_id: id,
        action: 'like'
      )
      notification.save!
    end
  end

  def create_notification_comment(current_user, comment_id)
    notification = Notification.new(
      visitor_id: current_user.id,
      visited_id: seller_id,
      ticket_id: id,
      comment_id: comment_id,
      action: 'comment'
    )
    notification.save! unless notification.visited_id === current_user.id
  end

  def create_notification_request(current_user)
    notification = Notification.new(
      visitor_id: current_user.id,
      visited_id: seller_id,
      ticket_id: id,
      action: 'request'
    )
    notification.save!
  end

  validates :thumbnail, presence: true
  validates :event_name, presence: true, length: { maximum: 30 }
  validates :event_date, presence: true
  validates :venue, presence: true, length: { maximum: 30 }
  validates :number_of_sheets, presence: true
  validates :shipping, presence: true
  validates :delivery_method, presence: true, length: { maximum: 30 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 300, less_than: 99_999 }
end

class Ticket < ApplicationRecord
  mount_uploader :thumbnail, ImageUploader
  # enum number_of_sheets: { }

  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :requests
  has_many :notifications, dependent: :destroy

  def liked_by(user)
    likes.where(user_id: user.id).exists?
  end

  validates :thumbnail, presence: true
  validates :event_name, presence: true, length: {maximum: 30}
  validates :event_date, presence: true
  validates :venue, presence: true, length: {maximum: 30}
  validates :number_of_sheets, presence: true
  validates :shipping, presence: true
  validates :delivery_method, presence: true, length: {maximum: 30}
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 300, less_than: 99999 }
end

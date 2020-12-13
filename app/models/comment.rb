# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :ticket, optional: true
  has_one :notification, dependent: :destroy

  validates :content, presence: true
end

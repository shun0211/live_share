class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :ticket, optional: true
  has_one :notification, dependent: :destroy
end

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates_uniqueness_of :user_id, scope: :ticket_id
end

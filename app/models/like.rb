# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates :user_id, uniqueness: { scope: :ticket_id }
end

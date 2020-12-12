# frozen_string_literal: true

class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :ticket, optional: true, inverse_of: :notifications
  belongs_to :comment, optional: true
  belongs_to :visitor, class_name: 'User'
  belongs_to :visited, class_name: 'User'
  belongs_to :message, optional: true
end

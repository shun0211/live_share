# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :content, presence: true
  after_create_commit { MessageBroadcastJob.perform_later self }
end

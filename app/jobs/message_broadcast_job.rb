# frozen_string_literal: true

class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast("room_channel_#{message.room_id}", { message: message })
    # ActionCable.server.broadcast("room_channel_#{message.room_id}", { message: render_message(message) })
  end
end

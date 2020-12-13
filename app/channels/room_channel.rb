# frozen_string_literal: true

class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create!(content: data['message'], user_id: current_user.id, room_id: params[:room])
    message = Message.where(room_id: params[:room]).order('created_at DESC').take
    partner = Room.find(params[:room]).users.where.not(id: current_user.id)
    Notification.create!(visitor_id: current_user.id, visited_id: partner[0].id, action: 'message', message_id: message.id)
  end
end

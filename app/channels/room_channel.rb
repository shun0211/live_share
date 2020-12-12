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
  end
end

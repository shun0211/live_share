# frozen_string_literal: true

class RoomsController < ApplicationController
  def index
    @rooms = current_user.rooms.includes(:messages).order('messages.created_at DESC')
    @active_room = @rooms.first
    @messages = @active_room.messages.order('created_at DESC').paginate(page: params[:page], per_page: 30) if @active_room
    gon.current_user_id = current_user.id
    @user = @active_room.users.where.not(id: current_user.id)
    gon.partner_avatar_url = @user[0].avatar.url
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @room = Room.create
    @entry_own = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry_partner = Entry.create(params.permit(:user_id).merge(room_id: @room.id))
    redirect_to room_path(@room.id)
  end

  def show
    @room = Room.find(params[:id])
    @rooms = current_user.rooms
    @user = @room.users.where.not(id: current_user.id)
    @messages = @room.messages.order('created_at DESC').paginate(page: params[:page], per_page: 30)
    gon.current_user_id = current_user.id
    gon.partner_avatar_url = @user[0].avatar.url
    respond_to do |format|
      format.html
      format.json
    end
  end
end

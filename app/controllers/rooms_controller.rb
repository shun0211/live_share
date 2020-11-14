class RoomsController < ApplicationController
  def create
    @room = Room.create
    @entry_own = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry_partner = Entry.create(params.permit(:user_id).merge(room_id: @room.id))
    redirect_to room_path(@room.id)

  end

  def show
    @room = Room.find(params[:id])
    # ログイン中のユーザの持つentriesテーブルの全レコード
    @my_entries = Entry.where(user_id: current_user.id)
    # ログイン中のユーザが持つすべてのroom_id取得
    my_room = []
    @my_entries.each do |my_entry|
      my_room << my_entry.room_id
    end
    # ログインユーザと同じ部屋を持つユーザのentriesテーブルの全レコード
    @partner_entries = Entry.where(room_id: my_room)
    # 同じ部屋を持つユーザのidを配列に格納
    partner_id = []
    @partner_entries.each do |partner_entry|
      partner_id << partner_entry.user_id
    end
    @users = User.where(id: partner_id).where.not(id: current_user.id)

    @partner = Entry.where(room_id: params[:id]).where.not(user_id: current_user.id)
    @messages = @room.messages
  end

end

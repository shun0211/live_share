class RoomsController < ApplicationController
  def show
    @users = User.all
    @room = Room.find(params[:id])
    @messages = @room.messages

  end
end

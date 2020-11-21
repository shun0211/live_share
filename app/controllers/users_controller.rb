class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:mypage]

  def show
    @user = User.find(params[:id])
    @listing_tickets = Ticket.where(seller_id: @user.id)
  end

  def mypage
    redirect_to user_path(current_user.id)
  end
end

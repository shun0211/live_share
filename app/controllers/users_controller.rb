class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @listing_tickets = Ticket.find_by(seller_id: @user.id)
  end
end

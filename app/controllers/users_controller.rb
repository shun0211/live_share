class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @listing_tickets = Ticket.find_by(seller_id: current_user.id)
  end
end

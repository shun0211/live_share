class TicketsController < ApplicationController
  def index
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.save!
  end

  private
  def ticket_params
    params.require(:ticket).permit(:number_of_sheets, :sheet_type, :price, :shipping, :delivery_method, :description, :event_name, :venue, :event_date)
  end


end

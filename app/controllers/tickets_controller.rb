class TicketsController < ApplicationController
  def index
  end

  def new
    @ticket = Ticket.new
    @events = Event.all
  end

  def create
  end

end

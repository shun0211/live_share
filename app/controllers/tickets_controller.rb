class TicketsController < ApplicationController
  def index
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)
    respond_to do |format|
      if @ticket.valid?
        @ticket.save!
        format.html
        format.json { render json: @ticket.errors.messages }
      else
        format.json { render json: @ticket.errors.messages }
      end
    end
  end

  def show
    @ticket = Ticket.find(params[:id])
  end

  private
  def ticket_params
    params.require(:ticket).permit(:number_of_sheets, :sheet_type, :price, :shipping, :delivery_method, :description, :event_name, :venue, :event_date, :id, :thumbnail)
  end

end

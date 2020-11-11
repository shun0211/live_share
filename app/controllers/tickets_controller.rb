class TicketsController < ApplicationController
  before_action :set_ticket, only: ["show", "edit", "update", "destroy"]

  def index
    @tickets = Ticket.paginate(page: params[:page], per_page: 20)
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.seller_id = current_user.id
    respond_to do |format|
      if @ticket.valid?
        @ticket.save!
        format.html {redirect_to root_path}
        format.json {render json: @ticket.errors.messages}
      else
        format.json {render json: @ticket.errors.messages}
      end
    end
  end

  def show
    @comments = @ticket.comments
    @comment = Comment.new
    gon.ticket = @ticket
  end

  def edit
  end

  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        @ticket.valid?
        format.html
        format.json {render json: @ticket.errors.messages}
      else
        @ticket.valid?
        format.json {render json: @ticket.errors.messages}
      end
    end
  end

  def destroy
    @ticket.destroy
    redirect_to root_path
  end

  private
  def ticket_params
    params.require(:ticket).permit(:number_of_sheets, :sheet_type, :price, :shipping, :delivery_method, :description, :event_name, :venue, :event_date, :id, :thumbnail)
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

end

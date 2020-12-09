# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :set_ticket, only: %w[show edit update destroy]

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
        format.html { redirect_to root_path }
      end
      format.json { render json: @ticket.errors.messages }
    end
  end

  def show
    @comments = @ticket.comments
    @comment = Comment.new
    gon.ticket = @ticket
    @my_entries = Entry.where(user_id: current_user.id)
    @partner_entries = Entry.where(user_id: @ticket.seller_id)
    @my_entries.each do |my_entry|
      @partner_entries.each do |partner_entry|
        if my_entry.room_id === partner_entry.room_id
          @exist_room = true
          @room_id = my_entry.room_id
        end
      end
    end
    @my_request = @ticket.requests.find_by(user_id: current_user.id, ticket_id: @ticket.id)
  end

  def edit; end

  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        @ticket.valid?
        format.html
        format.json { render json: @ticket.errors.messages }
      # else
      #   @ticket.valid?
      #   format.json { render json: @ticket.errors.messages }
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

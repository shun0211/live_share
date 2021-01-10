# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :set_ticket, only: %w[show edit update destroy]

  def index
    @tickets = Ticket.paginate(page: params[:page], per_page: 20)
  end

  def new_arrival
    @tickets = Ticket.all.order(created_at: "DESC").paginate(page: params[:page], per_page: 20)
    render :index
  end

  def trend
    @tickets = Ticket.select('tickets.*', 'count(likes.id) AS likes').left_joins(:likes).group('tickets.id').order('likes desc').paginate(page: params[:page], per_page: 20)
    render :index
  end

  def near
    @tickets = Ticket.all.where("event_date >= ?", Time.current).order(event_date: "ASC").paginate(page: params[:page], per_page: 20)
    render :index
  end

  def on_sale
    @tickets = Ticket.all.where(buyer_id: nil).order(event_date: "ASC").paginate(page: params[:page], per_page: 20)
    render :index
  end

  def new
    @ticket = Ticket.new
    gon.ticket = 'new_ticket'
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

    return unless user_signed_in?

    @my_entries = Entry.where(user_id: current_user.id)
    @partner_entries = Entry.where(user_id: @ticket.seller_id)
    @my_entries.each do |my_entry|
      @partner_entries.each do |partner_entry|
        if my_entry.room_id == partner_entry.room_id
          @exist_room = true
          @room_id = my_entry.room_id
        end
      end
    end
    @my_request = @ticket.requests.find_by(user_id: current_user.id, ticket_id: @ticket.id)
  end

  def edit
    gon.ticket = @ticket
  end

  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        @ticket.valid?
        format.html
        format.json { render json: @ticket.errors.messages }
      else
        @ticket.valid?
        format.json { render json: @ticket.errors.messages }
      end
    end
  end

  def destroy
    @ticket.destroy
    redirect_to root_path
  end

  def purchase
    ticket = Ticket.find(params[:id])
    taker = User.find(params[:taker_id])
    card = taker.cards.first
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
    Payjp::Charge.create(
      amount: ticket.price,
      customer: Payjp::Customer.retrieve(card.customer_id),
      currency: 'jpy'
    )
    ticket.buyer_id = taker.id
    ticket.save!
    flash[:notice] = "#{taker.nickname}さんに譲る処理が完了しました。"
    ticket.create_notification_purchase(current_user)
    redirect_to ticket_path(ticket)
  end

  private

  def ticket_params
    params.require(:ticket).permit(:number_of_sheets, :sheet_type, :price, :shipping, :delivery_method, :description, :event_name, :venue, :event_date, :id, :thumbnail)
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end
end

# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:mypage]
  before_action :set_search_form, only: %w[show following followers likes requests sold_tickets buyed_tickets]

  def show
    @user = User.find(params[:id])
    @listing_tickets = Ticket.where(seller_id: @user.id)
  end

  def mypage
    redirect_to user_path(current_user.id)
  end

  # フォロー中のユーザの表示
  def following
    @following_users = current_user.followings
  end

  # フォロワーのユーザの表示
  def followers
    @followers = current_user.followers
  end

  def likes
    @like_tickets = current_user.like_tickets
  end

  def requests
    @request_tickets = current_user.request_tickets
  end

  def sold_tickets
    @sold_tickets = current_user.sold_tickets
  end

  def buyed_tickets
    @buyed_tickets = current_user.buyed_tickets
  end

  private

  def set_search_form
    @q = Ticket.ransack(params[:q])
  end
end

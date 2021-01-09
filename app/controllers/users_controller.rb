# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:mypage]

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
end

# frozen_string_literal: true

class RelationshipsController < ApplicationController
  # フォローを行うメソッド
  def create
    @other_user = User.find(params[:follow_id])
    @relationship = current_user.follow(@other_user)
    @other_user.create_notification_follow(current_user)
    respond_to do |format|
      format.html { redirect_to user_path(@other_user.id) }
      format.js
      format.json { render json: @relationship }
    end
  end

  # アンフォローを行うメソッド
  def destroy
    @other_user = User.find(params[:follow_id])
    @relationship = current_user.unfollow(@other_user)
    respond_to do |format|
      format.html { redirect_to user_path(@other_user.id) }
      format.js
      format.json { render json: nil }
    end
  end
end

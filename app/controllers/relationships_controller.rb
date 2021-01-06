class RelationshipsController < ApplicationController
  # フォローを行うメソッド
  def create
    binding.pry
    other_user = User.find(params[:follow_id])
    @relationship = current_user.follow(other_user)
    respond_to do |format|
      format.json { render json: @relationship }
      format.html { redirect_to user_path(other_user.id) }
    end
  end

  # アンフォローを行うメソッド
  def destroy
    binding.pry
    other_user = User.find(params[:id])
    @relationship = current_user.unfollow(other_user)
    respond_to do |format|
      format.json { render json: nil }
      format.html { redirect_to user_path(other_user.id) }
    end
  end
end

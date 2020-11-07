class LikesController < ApplicationController
  def create
    @like = Like.new(like_params)
    @like.save!
  end

  def destroy
    @like = Like.find_by(user_id: params[:user_id], ticket_id: params[:ticket_id])
    @like.destroy
  end

  private
  def like_params
    params.permit(:ticket_id, :user_id)
  end

end

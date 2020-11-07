class LikesController < ApplicationController

  def create
    @like = Like.new(like_params)

    @like.save!
    @ticket = @like.ticket
    # respond_to do |format|
    #   format.json
    # end
  end

  def destroy
    @like = Like.find_by(user_id: params[:user_id], ticket_id: params[:ticket_id])
    @ticket = @like.ticket
    @like.destroy

    # repond_to do |format|
    #   format.json
    # end
  end

  private
  def like_params
    params.permit(:ticket_id, :user_id)
  end

end

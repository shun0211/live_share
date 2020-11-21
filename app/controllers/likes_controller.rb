class LikesController < ApplicationController

  def create
    @like = Like.new(like_params)

    @like.save!
    @ticket = @like.ticket
    # モデルから作られたインスタンスからメソッドを参照する際は、元になっているモデルのメソッドしか使用できない
    # メソッド内でインスタンスの値を「id」や「event_name」などのように書くことで持ってこれる
    @ticket.create_notification_like(current_user)
  end

  def destroy
    @like = Like.find_by(user_id: params[:user_id], ticket_id: params[:ticket_id])
    @ticket = @like.ticket
    @like.destroy
  end

  private
  def like_params
    params.permit(:ticket_id, :user_id)
  end

end

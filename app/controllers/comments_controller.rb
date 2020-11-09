class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save!
    respond_to do |format|
      format.html
      format.json
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.json {render json: @comment.id}
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:id, :content, :ticket_id, :created_at, :updated_at)
  end

end

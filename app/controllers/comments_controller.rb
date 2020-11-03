class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.save!
    respond_to do |format|
      format.html
      format.json
    end

  end

  private
  def comment_params
    params.require(:comment).permit(:id, :content, :user_id, :ticket_id, :created_at, :updated_at)
  end

end

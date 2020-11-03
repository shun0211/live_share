# json.extract! @comment, :id, :content, :created_at, :updated_at
# json.nickname @comment.user.nickname
# json.avatar @comment.user.avatar
# if @comment.ticket.seller_id === current_user_id
#   json.seller ture
# end
json.content @comment.content

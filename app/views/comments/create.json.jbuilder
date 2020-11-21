json.extract! @comment, :id, :content, :created_at, :updated_at
json.userNickname @comment.user.nickname
json.userAvatar @comment.user.avatar.url
if @comment.ticket.seller_id === current_user.id
  json.seller true
end

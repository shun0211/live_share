module LikesHelper
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end

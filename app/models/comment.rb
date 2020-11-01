class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :ticket, optional: true
end

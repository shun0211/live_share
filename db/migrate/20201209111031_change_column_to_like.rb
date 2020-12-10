class ChangeColumnToLike < ActiveRecord::Migration[6.0]
  def change
    add_index :likes, [:user_id, :ticket_id], unique: true
  end
end

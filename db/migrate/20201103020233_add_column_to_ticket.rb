class AddColumnToTicket < ActiveRecord::Migration[6.0]
  def change
    add_reference :tickets, :seller, foreign_key: { to_table: :users }
    add_reference :tickets, :buyer, foreign_key: { to_table: :users }
  end
end

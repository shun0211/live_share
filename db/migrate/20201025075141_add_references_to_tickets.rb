class AddReferencesToTickets < ActiveRecord::Migration[6.0]
  def change
    add_reference :tickets, :event, null: false, foreign_key: true
    add_column :tickets, :thumbnail, :string
  end
end

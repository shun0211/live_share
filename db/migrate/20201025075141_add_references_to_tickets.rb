class AddReferencesToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :thumbnail, :string
  end
end

class AddColumnToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :event_name, :string, null: false
    add_column :tickets, :venue, :string, null: false
    add_column :tickets, :event_date, :date, null: false
  end
end

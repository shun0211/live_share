class AddColumnToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :event_name, :string
    add_column :tickets, :venue, :string
    add_column :tickets, :event_date, :date
  end
end

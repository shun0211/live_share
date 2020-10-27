class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.integer :number_of_sheets
      t.string :sheet_type
      t.integer :price
      t.string :shipping
      t.string :delivery_method
      t.text :description
      t.timestamps
    end
  end
end

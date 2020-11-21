class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.string :sheet_type
      t.integer :price, null: false
      t.integer :shipping, null: false
      t.string :delivery_method, null: false
      t.integer :number_of_sheets, null: false
      t.text :description
      t.timestamps
    end
  end
end

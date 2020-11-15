class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.references :user, foreign_key: true
      t.references :ticket, foreign_key: true
      t.timestamps
    end
  end
end

class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.string :token, null: false, limit: 5
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tickets, :token, unique: true
  end
end

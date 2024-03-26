class AddValidToTicket < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :vazecka, :boolean, default: true
  end
end

class AddSoldToTicket < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :prodaden, :boolean, default: false
  end
end

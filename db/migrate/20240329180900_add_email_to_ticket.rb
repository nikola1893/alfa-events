class AddEmailToTicket < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :email, :string
  end
end

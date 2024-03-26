class RmValidInTickets < ActiveRecord::Migration[7.1]
  def change
    remove_column :tickets, :valid
  end
end

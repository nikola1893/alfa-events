class RemoveLimitt < ActiveRecord::Migration[7.1]
    def change
      change_column :tickets, :token, :string, null: false, limit: nil
    end
  end
  
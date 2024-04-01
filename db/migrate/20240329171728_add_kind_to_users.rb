class AddKindToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :kind, :string
  end
end

class AddEmailIndexToUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :email
  end
end

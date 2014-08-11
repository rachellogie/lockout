class AddLockedOutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :locked_out_at, :datetime
  end
end

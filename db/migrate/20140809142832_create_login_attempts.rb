class CreateLoginAttempts < ActiveRecord::Migration
  def change
    create_table :failed_login_attempts do |t|
      t.integer :user_id
      t.index :user_id
      t.datetime :time_failed

      t.timestamps
    end
  end
end

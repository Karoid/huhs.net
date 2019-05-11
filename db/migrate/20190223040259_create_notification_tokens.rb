class CreateNotificationTokens < ActiveRecord::Migration[4.2]
  def change
    create_table :notification_tokens do |t|
      t.string :endpoint
      t.string :p256dh_key
      t.string :auth_key
      t.integer :member_id
      t.timestamps null: false
    end
  end
end

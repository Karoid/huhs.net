class CreateKakaoChatLogins < ActiveRecord::Migration
  def change
    create_table :kakao_chat_logins do |t|
      t.string :user_key
      t.integer :member_id
      t.boolean :active, :default => false #승인, 미승인
      t.timestamps null: false
    end
  end
end

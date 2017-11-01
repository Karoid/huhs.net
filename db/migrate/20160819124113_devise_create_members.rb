class DeviseCreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      ## Database authenticatable
      t.string  :email,              null: false, default: ""
      t.string  :username,           null: false, default: ""
      t.integer :senior_number,      null: false, default: 1
      t.string  :tel,                null: false, default: "미입력"
      t.integer :major_id,           null: false, default: 1
      t.string  :image_url,          null: false, default: "/images/default_img.png"
      t.string  :encrypted_password, null: false, default: ""
      t.boolean :admin,              null: false, default: false
      t.boolean :staff,              null: false, default: false
      #role의 경우 다음과 같이 정합니다
      #0: 외부인
      #1: 준회원
      #2: 정회원
      #3: 졸업생
      t.integer :role,               null: false, default: 0
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :members, :email,                unique: true
    add_index :members, :reset_password_token, unique: true
    # add_index :members, :confirmation_token,   unique: true
    # add_index :members, :unlock_token,         unique: true
  end
end

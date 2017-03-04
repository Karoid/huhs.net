class CheckAttendenceCreateAttendenceLists < ActiveRecord::Migration
  def change
    create_table :attendence_lists do |t|
      t.integer    :user_id,    null: false
      t.integer    :code
      t.string     :name   ,    null: false
      t.datetime   :start  ,    null: false
      t.datetime   :end    ,    null: false
      t.timestamps null: false
    end

  end
end

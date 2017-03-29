class CheckAttendenceCreateAttendences < ActiveRecord::Migration
  def change
    create_table :attendences do |t|
      t.integer :attendence_list_id
      ## Database authenticatable
      t.integer :user_id
      t.string :user_name,              null: false

      t.timestamps null: false
    end

  end
end

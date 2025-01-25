class CreateScheduleItems < ActiveRecord::Migration[8.0]
  def change
    create_table :schedule_items do |t|
      t.string :name
      t.string :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :responsible_name
      t.string :responsible_email
      t.integer :schedule_type
      t.references :schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end

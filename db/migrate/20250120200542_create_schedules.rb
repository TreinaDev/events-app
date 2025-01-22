class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end

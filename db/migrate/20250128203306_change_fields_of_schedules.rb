class ChangeFieldsOfSchedules < ActiveRecord::Migration[8.0]
  def change
    remove_column :schedules, :end_date
    rename_column :schedules, :start_date, :date
  end
end

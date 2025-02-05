class CreateAnnouncements < ActiveRecord::Migration[8.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end

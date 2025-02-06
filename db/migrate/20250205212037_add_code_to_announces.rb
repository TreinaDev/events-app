class AddCodeToAnnounces < ActiveRecord::Migration[8.0]
  def change
    add_column :announcements, :code, :string
    add_index :announcements, :code, unique: true
  end
end

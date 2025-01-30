class AddUniqueIndexToSpeakers < ActiveRecord::Migration[8.0]
  def change
    add_index :speakers, :email, unique: true
  end
end

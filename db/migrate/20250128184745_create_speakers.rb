class CreateSpeakers < ActiveRecord::Migration[8.0]
  def change
    create_table :speakers do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :token, null: false

      t.timestamps
    end
    add_index :speakers, :token, unique: true
  end
end

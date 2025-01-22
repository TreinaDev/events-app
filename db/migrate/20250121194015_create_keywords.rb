class CreateKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :keywords do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :keywords, :value, unique: true
  end
end

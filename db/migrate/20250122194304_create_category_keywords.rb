class CreateCategoryKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :category_keywords do |t|
      t.references :category, null: false, foreign_key: true
      t.references :keyword, null: false, foreign_key: true

      t.timestamps
    end
  end
end

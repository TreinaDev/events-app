class CreateTicketBatches < ActiveRecord::Migration[8.0]
  def change
    create_table :ticket_batches do |t|
      t.string :name, null: false
      t.integer :tickets_limit, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.decimal :ticket_price, precision: 10, scale: 2, null: false
      t.integer :discount_option
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end

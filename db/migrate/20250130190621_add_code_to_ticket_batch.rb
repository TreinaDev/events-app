class AddCodeToTicketBatch < ActiveRecord::Migration[8.0]
  def change
    add_column :ticket_batches, :code, :string
    add_index :ticket_batches, :code
  end
end

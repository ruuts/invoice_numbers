class CreateInvoiceNumberSequences < ActiveRecord::Migration
  def change
    create_table :invoice_number_sequences do |t|
      t.string  :name
      t.integer :next_number, :default => 1
    end

    add_index :invoice_number_sequences, [:name], :unique => true
  end
end

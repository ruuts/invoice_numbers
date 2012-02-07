if ENV['orm'] == 'activerecord'

  ActiveRecord::Schema.define :version => 1 do
    create_table :invoice_number_sequences, :force => true do |t|
      t.string  :name
      t.integer :next_number, :default => 1
    end
  end

end

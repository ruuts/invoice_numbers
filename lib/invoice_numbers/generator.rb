module InvoiceNumbers
  class Generator
    def self.next_invoice_number( sequence_name = :default )
      sequence = InvoiceNumberSequence.by_sequence_name sequence_name
      sequence.increment!
    end
  end
end

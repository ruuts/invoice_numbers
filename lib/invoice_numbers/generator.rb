module InvoiceNumbers
  class InvoiceNumberSequence < ActiveRecord::Base
    def increment!
      transaction do
        lock!
        number = self.next_number
        self.next_number = number + 1
        self.save!
        number
      end
    end
  end

  class Generator
    def self.next_invoice_number( sequence_name = :default )
      sequence = InvoiceNumberSequence.find_or_create_by_name sequence_name
      sequence.increment!
    end
  end
end

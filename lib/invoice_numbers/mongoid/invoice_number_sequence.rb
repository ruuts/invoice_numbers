class InvoiceNumberSequence
  include Mongoid::Document
  field :next_number, type: Integer, default: 0

  def self.by_sequence_name( sequence_name )
    InvoiceNumberSequence.find_or_create_by( name: sequence_name )
  end

  def increment!
    inc(:next_number, 1)
  end
end

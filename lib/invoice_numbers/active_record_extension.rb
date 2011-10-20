module InvoiceNumbers
  module ActiveRecordExtension
    def self.included( base )
      base.send( :extend, ClassMethods )
    end

    module ClassMethods
      def has_invoice_number( field_name, options = {} )
        invoice_number_field         = field_name
        invoice_number_sequence      = options[:invoice_number_sequence]
        invoice_number_sequence    ||= self.name.to_s.underscore
        invoice_number_assign_if     = options[:assign_if]

        if invoice_number_assign_if
          before_save :assign_invoice_number
        end

        send(:define_method, :assign_invoice_number) do
          transaction do
            if read_attribute( invoice_number_field ).blank? 
              if invoice_number_assign_if.nil? or invoice_number_assign_if.call(self)
                sequence = invoice_number_sequence.respond_to?(:call) ? invoice_number_sequence.call(self) : invoice_number_sequence
                write_attribute( invoice_number_field, Generator.next_invoice_number( sequence ) )
              end
            end
          end
        end
      end
    end
  end
end

if defined?(ActiveRecord::Base)
  require File.dirname( __FILE__ ) + '/generators/invoice_numbers_generator'
  require File.dirname( __FILE__ ) + '/invoice_numbers/active_record/invoice_number_sequence'
  require File.dirname( __FILE__ ) + '/invoice_numbers/generator'
  require File.dirname( __FILE__ ) + '/invoice_numbers/invoice_numbers'
  ActiveRecord::Base.send :include, InvoiceNumbers::InvoiceNumbers
elsif defined?(Mongoid::Document)
  require File.dirname( __FILE__ ) + '/invoice_numbers/mongoid/invoice_number_sequence'
  require File.dirname( __FILE__ ) + '/invoice_numbers/generator'
  require File.dirname( __FILE__ ) + '/invoice_numbers/invoice_numbers'
end


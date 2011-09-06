require 'active_record/railtie'

require File.dirname( __FILE__ ) + '/invoice_numbers/generator'
require File.dirname( __FILE__ ) + '/invoice_numbers/active_record_extension'

ActiveRecord::Base.send :include, InvoiceNumbers::ActiveRecordExtension

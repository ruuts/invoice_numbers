require 'test/unit'
require File.dirname( __FILE__ ) + '/database_configuration'
require File.dirname( __FILE__ ) + '/database_schema'
require 'database_cleaner'
require 'minitest/spec'
require 'invoice_numbers'

describe InvoiceNumbers::Generator do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  describe 'next_invoice_number' do
    it 'should return 1 the first time we request a certain sequence' do
      InvoiceNumbers::Generator.next_invoice_number(:test).must_equal 1
    end

    it 'should increment with one on future request of a certain sequence' do
      InvoiceNumbers::Generator.next_invoice_number(:test)
      InvoiceNumbers::Generator.next_invoice_number(:test).must_equal 2
    end

    it 'should not increment other sequences' do
      InvoiceNumbers::Generator.next_invoice_number(:test)
      InvoiceNumbers::Generator.next_invoice_number(:other)
      InvoiceNumbers::Generator.next_invoice_number(:test).must_equal 2
    end
  end
end

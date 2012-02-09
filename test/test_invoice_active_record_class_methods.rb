require 'test/unit'
require 'database_cleaner'
require 'minitest/spec'
require 'invoice_numbers'
require File.dirname( __FILE__ ) + '/database_configuration'

if ENV['orm'] == 'activerecord'

  ActiveRecord::Schema.define :version => 1 do
    create_table :orders, :force => true do |t|
      t.boolean :finished,    :default => false
      t.string :dummy_nr
      t.string :invoice_nr
    end
    create_table :reservations, :force => true do |t|
      t.boolean :finished,    :default => false
      t.string :invoice_nr
    end
    create_table :invoices, :force => true do |t|
      t.boolean :finished,    :default => false
      t.string :invoice_nr
      t.string  :customer
     end
  end

  class Order < ActiveRecord::Base
    has_invoice_number :invoice_nr, :assign_if => lambda { |order| order.finished? }
    has_invoice_number :dummy_nr,   :invoice_number_sequence => :dummy
  end

  class Reservation < ActiveRecord::Base
    has_invoice_number :invoice_nr, :invoice_number_sequence => :shared
  end

  class Invoice < ActiveRecord::Base
    has_invoice_number :invoice_nr, :invoice_number_sequence => lambda { |invoice| "#{invoice.customer}" }, :prefix => true
  end

elsif ENV['orm'] == 'mongoid'

  class Order
    include Mongoid::Document
    include InvoiceNumbers::InvoiceNumbers

    field :finished, 	type: Boolean, default: false
    field :dummy_nr, 	type: String
    field :invoice_nr, 	type: String

    has_invoice_number :invoice_nr, :assign_if => lambda { |order| order.finished? }
    has_invoice_number :dummy_nr,   :invoice_number_sequence => :dummy
  end

  class Reservation
    include Mongoid::Document
    include InvoiceNumbers::InvoiceNumbers

    field :finished, 	type: Boolean, default: false
    field :invoice_nr, 	type: String

    has_invoice_number :invoice_nr, :invoice_number_sequence => :shared
  end

  class Invoice
    include Mongoid::Document
    include InvoiceNumbers::InvoiceNumbers

    field :finished, 	type: Boolean, default: false
    field :invoice_nr, 	type: String
    field :dummy_nr, 	type: String
    field :customer, 	type: String

    has_invoice_number :invoice_nr, :invoice_number_sequence => lambda { |invoice| "#{invoice.customer}" }, :prefix => true
  end

end

describe Invoice do
  before do
    @invoice = Invoice.new(:customer => "jan")
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  it 'assigns an invoice number when forced' do
    @invoice.assign_invoice_number
    @invoice.save
    @invoice.invoice_nr.must_equal "jan1"
  end

  it 'uses the shared sequence' do
    invoice2 = Invoice.new(:customer => "henk")
    invoice2.assign_invoice_number
    invoice2.invoice_nr.must_equal "henk1"
    invoice3 = Invoice.new(:customer => "henk")
    invoice3.assign_invoice_number
    invoice3.invoice_nr.must_equal "henk2"
    @invoice.assign_invoice_number
    @invoice.invoice_nr.must_equal "jan1"
  end
end

describe Reservation do
  before do
    @reservation = Reservation.new
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  it 'does not assign an invoice number' do
    @reservation.save
    @reservation.invoice_nr.must_be_nil
  end

  it 'assigns an invoice number when forced' do
    @reservation.assign_invoice_number
    @reservation.save
    @reservation.invoice_nr.must_equal 1.to_s
  end

  it 'uses the shared sequence' do
    InvoiceNumbers::Generator.next_invoice_number(:shared)
    InvoiceNumbers::Generator.next_invoice_number(:shared)
    @reservation.assign_invoice_number
    @reservation.invoice_nr.must_equal 3.to_s
  end
end

describe Order do
  before do
    @order = Order.new
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  it 'does not assign an invoice number' do
    @order.save
    @order.invoice_nr.must_be_nil
  end

  it 'assigns an invoice number when finished' do
    @order.finished = true
    @order.save
    @order.invoice_nr.must_equal 1.to_s
  end

  it 'does not update an invoice number once assigned' do
    @order.finished = true
    @order.save
    @order.invoice_nr.must_equal 1.to_s
    @order.invoice_nr_will_change! # force a new save
    @order.save
    @order.invoice_nr.must_equal 1.to_s
  end

  it 'uses the order sequence' do
    InvoiceNumbers::Generator.next_invoice_number(:order)
    InvoiceNumbers::Generator.next_invoice_number(:order)
    @order.finished = true
    @order.assign_invoice_nr
    @order.invoice_nr.must_equal 3.to_s
  end
end

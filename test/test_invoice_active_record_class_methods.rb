require 'test/unit'
require 'database_cleaner'
require 'minitest/spec'
require 'invoice_numbers'
require File.dirname( __FILE__ ) + '/database_configuration'

ActiveRecord::Schema.define :version => 1 do
  create_table :orders, :force => true do |t|
    t.boolean :finished,    :default => false
    t.integer :invoice_nr
  end
  create_table :reservations, :force => true do |t|
    t.boolean :finished,    :default => false
    t.integer :invoice_nr
  end
end

class Order < ActiveRecord::Base
  has_invoice_number :invoice_nr, :assign_if => lambda { |order| order.finished? }
end

class Reservation < ActiveRecord::Base
  has_invoice_number :invoice_nr, :invoice_number_sequence => :shared
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
    @reservation.invoice_nr.must_equal 1
  end

  it 'uses the shared sequence' do
    InvoiceNumbers::Generator.next_invoice_number(:shared)
    InvoiceNumbers::Generator.next_invoice_number(:shared)
    @reservation.assign_invoice_number
    @reservation.invoice_nr.must_equal 3
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
    @order.invoice_nr.must_equal 1
  end

  it 'does not update an invoice number once assigned' do
    @order.finished = true
    @order.save
    @order.invoice_nr.must_equal 1
    @order.invoice_nr_will_change! # force a new save
    @order.save
    @order.invoice_nr.must_equal 1
  end

  it 'uses the order sequence' do
    InvoiceNumbers::Generator.next_invoice_number(:order)
    InvoiceNumbers::Generator.next_invoice_number(:order)
    @order.finished = true
    @order.assign_invoice_number
    @order.invoice_nr.must_equal 3
  end
end

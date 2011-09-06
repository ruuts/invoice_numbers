require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'db/test.sqlite3',
  :pool     => 5
)

if ENV['orm'] == 'activerecord'

  require 'active_record'
  require 'sqlite3'

  ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => 'db/test.sqlite3',
    :pool     => 5
  )

elsif ENV['orm'] == 'mongoid'

  require 'mongoid'

  Mongoid.configure do |config|
    config.master = Mongo::Connection.new.db("invoice_number_generator")
  end

end

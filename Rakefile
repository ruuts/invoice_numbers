require 'rubygems'
require 'rake/testtask'
require File.dirname( __FILE__ ) + '/test/database_configuration'
require File.dirname( __FILE__ ) + '/test/database_schema'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test*.rb']
end

require 'rubygems'
require 'spec'
require 'dm-hbase-adapter'
require 'dm-core'
require 'ruby-debug'

DataMapper.setup(:default, 
                 :adapter => 'hbase', 
                 :hostname  => 'localhost',
                 :port      => 8080)
class Person
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String
  property :age,        Integer

end


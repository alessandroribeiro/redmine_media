#!/bin/ruby

require 'rubygems'
require 'aws/s3'

AWS::S3::Base.establish_connection!( :access_key_id => '146Z4BQFX3ZKA8R04PG2', :secret_access_key => 'Qo/t8fV7WZLwGwKKViJmz736AiKAIH76QyJtUYXr' )


file = "example.txt"

puts "copying file"
AWS::S3::S3Object.store("example.txt",open("example.txt"),"integritas/redmine/12345")

 

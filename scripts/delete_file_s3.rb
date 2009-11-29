#!/bin/ruby

require 'rubygems'
require 'aws/s3'

AWS::S3::Base.establish_connection!( :access_key_id => '146Z4BQFX3ZKA8R04PG2', :secret_access_key => 'Qo/t8fV7WZLwGwKKViJmz736AiKAIH76QyJtUYXr' )

redmine_folder = "integritas/redmine_$folder$"

file = "example.txt"

puts "deleting file"
AWS::S3::S3Object.delete("example.txt","integritas/redmine")

 

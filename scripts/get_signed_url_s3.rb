#!/bin/ruby

require 'rubygems'
require 'aws/s3'

AWS::S3::Base.establish_connection!( :access_key_id => '146Z4BQFX3ZKA8R04PG2', :secret_access_key => 'Qo/t8fV7WZLwGwKKViJmz736AiKAIH76QyJtUYXr' )

redmine_folder = "integritas/redmine_$folder$"

bucket_integritas = AWS::S3::Bucket.find(redmine_folder)

puts "bucket_integritas = #{bucket_integritas}"

file = "example.txt"

five_hours = 5*60*60

url = AWS::S3::S3Object.url_for(file,"integritas/redmine", :expires_in=>five_hours)

puts "url = #{url}"

url_ssl = AWS::S3::S3Object.url_for(file,"integritas/redmine", :use_ssl=>true, :expires_in=>five_hours)

puts "url_ssl = #{url_ssl}"



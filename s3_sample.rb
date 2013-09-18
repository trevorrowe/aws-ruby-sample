#!/usr/bin/env ruby

# Copyright 2011-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'rubygems'
require 'bundler/setup'
require 'aws-sdk'
require 'uuid'

(file_name,) = ARGV
unless file_name
  puts "Usage: s3_sample.rb <FILE_NAME>"
  exit 1
end

# get an instance of the S3 interface using the default configuration
s3 = AWS::S3.new

# build a unique bucket name based on a unique ID
uuid = UUID.new
bucket_name = "ruby-sdk-sample-#{uuid.generate}"

# create a bucket
b = s3.buckets.create(bucket_name)

# upload a file
basename = File.basename(file_name)
o = b.objects[basename]
o.write(:file => file_name)

puts "Uploaded #{file_name} to:"
puts o.public_url

# generate a presigned URL
puts "\nUse this URL to download the file:"
puts o.url_for(:read)

puts "(press any key to delete the object)"
$stdin.getc

o.delete

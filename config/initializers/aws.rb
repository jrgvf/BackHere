require 'aws-sdk-v1'
require 'aws-sdk'

S3Client = Aws::S3::Client.new(
    access_key_id: ENV['AWS_ACCESS_KEY'],
    secret_access_key: ENV['AWS_SECRET_KEY'],
    region: ENV['AWS_REGION']
) 
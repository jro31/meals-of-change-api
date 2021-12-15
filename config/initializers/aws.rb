require 'aws-sdk-s3'

Aws.config.update({
  region: ENV['S3_BUCKET_REGION'],
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
})

# TODO - Update production bucket setting as per https://elliott-king.github.io/2020/09/s3-heroku-rails/#s3-buckets
S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])

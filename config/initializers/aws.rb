
require 'aws-sdk-s3'

begin
  s3 = Aws::S3::Resource.new(
    region: 'eu-west-3',
    access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
  )
  s3.bucket('musicast').objects.limit(1).to_a
  puts "Connected to S3 successfully."
rescue => e
  puts "Failed to connect to S3: #{e.message}"
end

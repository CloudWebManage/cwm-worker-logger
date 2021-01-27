#!/usr/bin/ruby

# frozen-string-literal: true

require 'net/http'

http = Net::HTTP.new('127.0.0.1', 8500)
header = { 'Content-Type' => 'application/json' }

File.readlines('./tests/integration/logs').each do |line|
  req = Net::HTTP::Post.new('/logs', header)
  req.body = line
  http.request(req)
end

# Wait for flush i.e. 10s
sleep(10)

EXPECTED_OUTPUT = {
  'deploymentid:minio-metrics:docker-compose-http:bytes_in' => '76727',
  'deploymentid:minio-metrics:docker-compose-http:bytes_out' => '114767',
  'deploymentid:minio-metrics:docker-compose-http:num_requests_in' => '15',
  'deploymentid:minio-metrics:docker-compose-http:num_requests_out' => '7',
  'deploymentid:minio-metrics:docker-compose-http:num_requests_misc' => '5'
}.freeze

EXPECTED_OUTPUT.each do |key, value|
  output = `redis-cli GET #{key}`
  output.chomp!
  if output != value
    puts "ERROR: [#{key} != #{value}] Got: #{output}, Expected: #{value}"
    return -1
  end
end

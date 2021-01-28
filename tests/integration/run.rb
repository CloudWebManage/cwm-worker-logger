# frozen-string-literal: true

require 'net/http'

puts 'Starting integration test...'

http = Net::HTTP.new('127.0.0.1', 8500)
header = { 'Content-Type' => 'application/json' }.freeze

File.readlines('./tests/integration/logs').each_with_index do |line, index|
  print "Sending request # #{index + 1}... "
  req = Net::HTTP::Post.new('/logs', header)
  req.body = line
  http.request(req)
  puts '[OK]'
end

print 'Waiting for flush interval... '
sleep(10)
puts '[OK]'

print 'Verifying data from Redis server... '

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
  unless output == value
    puts "ERROR: [#{key} != #{value}] Got: #{output}, Expected: #{value}"
    return -1
  end
end

puts '[OK]'
puts 'Integration test completed successfully!'

# frozen-string-literal: true

require 'net/http'

HOST = '127.0.0.1'
PORT = 8500
URL_PATH = '/logs'
LOGS_FILE_PATH = './tests/integration/logs'
FLUSH_INTERVAL_WAIT_SECS = 10

EXPECTED_OUTPUT = {
  'deploymentid:minio-metrics:docker-compose-http:bytes_in' => '76727',
  'deploymentid:minio-metrics:docker-compose-http:bytes_out' => '114767',
  'deploymentid:minio-metrics:docker-compose-http:num_requests_in' => '15',
  'deploymentid:minio-metrics:docker-compose-http:num_requests_out' => '7',
  'deploymentid:minio-metrics:docker-compose-http:num_requests_misc' => '5'
}.freeze

puts "Sending requests to http://#{HOST}:#{PORT}#{URL_PATH}"

http = Net::HTTP.new(HOST, PORT)
header = { 'Content-Type' => 'application/json' }.freeze

File.readlines(LOGS_FILE_PATH).each_with_index do |line, index|
  print "Request # #{index + 1}\t"
  req = Net::HTTP::Post.new(URL_PATH, header)
  req.body = line
  http.request(req)
  puts '[OK]'
end

print "Waiting for flush interval [#{FLUSH_INTERVAL_WAIT_SECS}s]... "
sleep(FLUSH_INTERVAL_WAIT_SECS)
puts '[OK]'

print 'Verifying data from Redis server... '

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

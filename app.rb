require_relative 'manager'
require 'net/https'
require 'uri'

include TTx

data = Manager.new.load
header = {'Content-Type' => 'Content-Type: "application/soap+xml"; charset=utf-8'}

uri          = URI.parse('https://sws3-crt.cert.sabre.com/')
http         = Net::HTTP.new(uri.host, uri.port) 
http.use_ssl = true

result  = http.post(uri.path, data, header)

puts result.body

require 'net/https'
require 'uri'

require_relative 'manager'
require_relative 'create_session_request'


session_req = TTx::CreateSessionRequest.new('124260', 'APPRED17', 'G7RE', 'AA')

puts TTx::Manager.new.create_session
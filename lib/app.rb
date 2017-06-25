require 'sinatra'
require_relative 'manager'

before do
  @@session_token ||= TTx::Manager.new.create_session
end


get '/perro' do 
    @@session_token
end 
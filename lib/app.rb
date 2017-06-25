require 'sinatra'
require 'active_support/all'
require_relative 'ttx/manager'
require_relative 'ttx/hotel.rb'
require_relative 'ttx/city.rb'
require_relative 'ttx/review.rb'
require_relative 'ttx/restaurant.rb'
require_relative 'ttx/attraction.rb'
require_relative 'ttx/price.rb'
require_relative 'ttx/rating'
require_relative 'init.rb'

include TTx

init = Init.new

before do
  #@@session_token ||= TTx::Manager.new.create_session
end


get '/perro' do 
    #@@session_token
end


get '/city_to_code' do

  query = params[:city].downcase
  init.hashCities.select { |key, value|  value.city.include? query  }.to_json

end

get '/get_avail_hotels' do

  check_in      = params[:check_in]
  check_out     = params[:check_out]
  city          = params[:city]
  rooms         = params[:rooms]
  guest         = params[:guests]
  hotel_options = params[:hotel_options]
  room_options  = params[:room_options]

  if hotel_options.nil?
    hotel_options = []
  elsif
  hotel_options = hotel_options.split(",")
  end

  if room_options.nil?
    room_options = []
  elsif
  room_options = room_options.split(",")
  end

  #ToDo
  #ToDo create soap request for SABRE
  #ToDo create token for sabre session
  #ToDo send the request created with search command
  #ToDo change the next line to use the Sabre response instead the xml file

  init.hotels_array.select {

      |value| ( (hotel_options + room_options ) - (value.hotel_amenities + value.room_amenities) ).empty?


  }.to_json

end
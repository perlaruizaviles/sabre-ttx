require 'sinatra'
require 'active_support/all'
require 'date'

require_relative 'ttx/manager'
require_relative 'ttx/hotel'
require_relative 'ttx/city'
require_relative 'ttx/review'
require_relative 'ttx/restaurant'
require_relative 'ttx/attraction'
require_relative 'ttx/price'
require_relative 'ttx/rating'
require_relative 'ttx/init'
require_relative 'ttx/search_command'

include TTx

init = Init.new

set :public_folder, File.dirname(__FILE__) + './../public/'

before do
    @@session_token ||= TTx::Manager.new.create_session
end

get '/token' do
  @@session_token
end

get '/city_to_code' do

    query = params[:city].downcase
    init.hashCities.select { |key, value|   value.city.include? query   }.to_json

end

get '/get_avail_hotels' do

    search_command              = SearchCommand.new
    search_command.check_in     = Date.parse(params[:check_in])
    search_command.check_out    = Date.parse(params[:check_out])
    search_command.city_code    = params[:city]
    search_command.rooms        = params[:rooms]
    search_command.guest_number = params[:guests]
    hotel_options               = params[:hotel_options]
    room_options                = params[:room_options]

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

    search_command.hotel_options = hotel_options
    search_command.room_options  = room_options


    manager = TTx::Manager.new(@@session_token)
    hotels  = manager.get_hotel_avail(search_command)
    

    hotels.to_json

end


get '/get_profile' do
  init.woman_profile_array.to_json
end

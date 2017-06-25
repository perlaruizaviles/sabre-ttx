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
  @@session_token ||= TTx::Manager.new.create_session
end


get '/perro' do 
    @@session_token
end


get '/city_to_code' do

  query = params[:city].downcase
  init.hashCities.select { |key, value|  value.city.include? query  }.to_json

end
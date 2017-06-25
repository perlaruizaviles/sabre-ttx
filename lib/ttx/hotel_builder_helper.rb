require_relative 'rating'
require_relative 'room_codes'
require_relative 'init'

module TTx
    class HotelBuilderHelper
        def initialize
            @@init       = Init.new 
            @@room_codes = RoomCodes.new
        end

        def build_hotel(element)

            code              = element.attr('HotelCode')
            city_code         = element.attr('HotelCityCode')
            name              = element.attr('HotelName')
            latitude          = element.attr('Latitude')
            longitude         = element.attr('Longitude')
            address           = ""
            phone             = ""
            fax               = ""
            price             = ""
            special_offers    = false
            hotel_amenities   = []
            room_amenities    = []
            rooms             = []

            element.children.each do |child|

              case child.name
                when "PropertyOptionInfo"
                  child.children.each do |grantChild|
                    if (grantChild.attr("Ind") == 'true')
                      if grantChild.name.downcase.include?("room")
                        room_amenities << grantChild.name.downcase
                      else
                        hotel_amenities << grantChild.name.downcase
                      end
                    end
                end

                when "ContactNumbers"
                  child.children.each do |grantChild|
                    if (grantChild.attr("Phone"))
                      phone = grantChild.attr("Phone")
                    end
                    if (grantChild.attr("Fax"))
                      fax = grantChild.attr("Fax")
                    end
                  end 

                when "RoomRate"
                  rooms << @@room_codes.room_code_to_meaning(child.attr("RateLevelCode"))

                when "Address"
                  address = child.text

                when "RateRange"
                  price = build_price(child)

                when "SpecialOffers"
                  special_offers = child.attr("Ind")
                end
            end

            #  MOCK for reviews/price/attractions starts here 
            if price == ""
              min   = rand(90..400)
              max   = rand(min..600)
              price = Price.new( '%.2f' % min , '%.2f' % max )
            end

            number_of_reviews = rand(1..50)

            random_reviews_array      = []
            random_attractions_array  = []
            random_restaurants_array  = []

            number_of_attractions = 4
            number_of_restaurants = 4

            if city_code.downcase == "nyc"
                random_reviews_array      = @@init.reviews_nyc.sample(number_of_reviews)
                random_attractions_array  = @@init.attractions_nyc.sample(number_of_attractions)
                random_restaurants_array  = @@init.restaurants_nyc.sample(number_of_restaurants)
            elsif
                random_reviews_array      = @@init.reviews_sfo.sample(number_of_reviews)
                random_attractions_array  = @@init.attractions_sfo.sample(number_of_attractions)
                random_restaurants_array  = @@init.restaurants_sfo.sample(number_of_restaurants)
            end

            sum          = random_reviews_array.map {|review| review.rating.to_i }.sum
            rating_hotel = build_rating((sum.to_f / random_reviews_array.size.to_f).round(1))


            Hotel.new( code, city_code, name, latitude, longitude, address, phone,
                       fax, price, rating_hotel, special_offers, hotel_amenities, room_amenities, random_attractions_array,
                       random_restaurants_array, rooms, random_reviews_array )

        end

        def build_rating(rating_value)
          result       = Rating.new
          result.value = rating_value

          case rating_value
            when 0..2
                result.category = "Not bad"
            when 2..3
                result.category = "Regular"
            when 3..3.5
                result.category = "Good"
            when 3.6..4
                result.category = "Very Good"
            when 4..4.5
                result.category = "Fabulous"
            when 4.5..5
                result.category = "Superb!!"
          end

            result
        end
    end 
      
end
require 'sinatra'
require 'json'

module TTx

  class Init

    attr_accessor :hashCities
    attr_accessor :hotels_array_nyc
    attr_accessor :hotels_array_sfo

    def initialize

      file        = TTx::Assets.load_file('airports.json')
      parsed      = JSON.parse(file)
      @hashCities = Hash.new
      @hashCities = parsed["airports"].map { |airport| [airport['iata'].downcase, build_city(airport)] }.to_h

      @restaurants_nyc = []
      @restaurants_sfo = []

      @reviews_nyc     = []
      @reviews_sfo     = []

      @attractions_nyc = []
      @attractions_sfo = []

      parsed            = JSON.parse( TTx::Assets.load_file('restaurants_nyc.json') )
      @restaurants_nyc  = parsed["restaurants"].map { |rest| build_restaurant( rest ) }

      parsed       = JSON.parse( TTx::Assets.load_file('restaurants_sfo.json'))
      @restaurants_sfo = parsed["restaurants"].map { |rest| build_restaurant( rest ) }

      parsed       = JSON.parse( TTx::Assets.load_file('reviews_nyc.json'))
      @reviews_nyc     = parsed["reviews"].map { |review| build_review(review) }

      parsed       = JSON.parse( TTx::Assets.load_file('reviews_sfo.json'))
      @reviews_sfo = parsed["reviews"].map { |review| build_review(review) }

      parsed       = JSON.parse( TTx::Assets.load_file('attractions_nyc.json'))
      @attractions_nyc = parsed["attractions"].each { |attraction| build_attraction(attraction) }

      parsed       = JSON.parse( TTx::Assets.load_file('attractions_sfo.json'))
      @attractions_sfo = parsed["attractions"].each { |attraction| build_attraction(attraction) }


      #
      # @doc              = Nokogiri::XML(File.read("lib/resources/OTA_HotelAvailLLSRS-Example2_NYC.xml"))
      # @hotels_array_nyc = @doc.xpath("//*[@HotelCode]").map {|d| create_hotel(d , "nyc") }
      #
      # @doc              = Nokogiri::XML(File.read("lib/resources/OTA_HotelAvailLLSRS-Example1_SFO.xml"))
      # @hotels_array_sfo = @doc.xpath("//*[@HotelCode]").map {|d| create_hotel(d , "nyc") }

    end

  end

  def create_hotel( d , city )

    code              = d.attr('HotelCode')
    city_code         = d.attr('HotelCityCode')
    name              = d.attr('HotelName')
    latitude          = d.attr('Latitude')
    longitude         = d.attr('Longitude')
    address           = ""
    phone             = ""
    fax               = ""
    price             = ""
    special_offers    = false
    hotel_amenities   = []
    room_amenities    = []
    rooms             = []

    d.children.each {|child|

      case child.name

        when "PropertyOptionInfo"
          child.children.each {|grantChild|

            if (grantChild.attr("Ind") == 'true')

              if grantChild.name.downcase.include? "room"
                room_amenities << grantChild.name.downcase
              else
                hotel_amenities << grantChild.name.downcase
              end

            end

          }

        when "ContactNumbers"
          child.children.each {|grantChild|

            if (grantChild.attr("Phone"))
              phone = grantChild.attr("Phone")
            end

            if (grantChild.attr("Fax"))
              fax = grantChild.attr("Fax")
            end

          }

        when "RoomRate"
          #this has to be converted to something meaningful
          rooms << child.attr("RateLevelCode")

        when "Address"
          address = child.text

        when "RateRange"
          price = build_price( child )

        when "SpecialOffers"
          special_offers = child.attr("Ind")

      end

    }

    if price == ""
      max = 2
      min = 1
      if city == "nyc"
          min = rand(100..200 )
          max = rand(min..800 )
      elsif
          min = rand(90..400 )
          max = rand(min..600 )
      end

      price = Price.new( '%.2f' % min , '%.2f' % max )

    end

    number_of_reviews = rand(1..50 )

    random_reviews_array      = []
    random_attractions_array  = []
    random_restaurants_array  = []

    number_of_attractions = 4
    number_of_restaurants = 4

    if city == "nyc"
        random_reviews_array      = @reviews_nyc.sample( number_of_reviews )
        random_attractions_array  = @attractions_nyc.sample( number_of_attractions )
        random_restaurants_array   = @restaurants_nyc.sample ( number_of_restaurants )
    elsif
        random_reviews_array      = @reviews_sfo.sample( number_of_reviews )
        random_attractions_array  = @attractions_sfo.sample( number_of_attractions )
        random_restaurants_array   = @restaurants_sfo.sample ( number_of_restaurants )
    end

    sum = 0;
    random_reviews_array.each {
        | review | sum += review.rating.to_i
    }

    rating_hotel = build_rating ( (sum.to_f / random_reviews_array.size.to_f).round(1) )


    Hotel.new( code, city_code, name, latitude, longitude, address, phone,
               fax, price, rating_hotel, special_offers, hotel_amenities, room_amenities, random_attractions_array,
               random_restaurants_array, rooms, random_reviews_array )

  end


  private
  def build_review(review)
    result          = Review.new
    result.title    = review["title"]
    result.user     = review["user"]
    result.content  = review["content"]
    result.date     = review["date"]
    result.rating   = review["rating"]

    result
  end

  def build_attraction(attraction)
    result          = Attraction.new
    result.name     = attraction["name"]
    result.rating   = attraction["rating"]
    result.distance = attraction["distance"]

    result
  end

  def build_city(airport)
    city         = City.new
    city.name    =  airport["name"].downcase
    city.city    =  airport["city"].downcase
    city.country =  airport["country"].downcase
    city.iata    =  airport["iata"].downcase

    city
  end

  def build_restaurant(restaurant)
    result          = Restaurant.new
    result.name     = restaurant["name"]
    result.rating   = restaurant["rating"]
    result.distance = restaurant["distance"]

    result
  end

  def build_price( price_rate )
    result     = Price.new
    result.min = price_rate.attr("Min")
    result.max = price_rate.attr("Max")

    result
  end

  def build_rating ( rating_value )
    result       = Rating.new
    result.value = rating_value

    case rating_value

      when 1..3
        result.category = "Good"
      when 3..4
        result.category = "Very Good"
      when 4..5
        result.category = "Excellent"
    end

    result
  end
end

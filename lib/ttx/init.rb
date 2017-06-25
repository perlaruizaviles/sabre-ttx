
require 'json'

module TTx

  class Init

    attr_accessor :hashCities
    attr_accessor :hotels_array

    attr_reader :reviews_nyc
    attr_reader :attractions_nyc
    attr_reader :restaurants_nyc
    attr_reader :reviews_sfo
    attr_reader :attractions_sfo
    attr_reader :restaurants_sfo



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

    end

  end

  
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

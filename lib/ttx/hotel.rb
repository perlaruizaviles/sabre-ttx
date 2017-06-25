module TTx

  class Hotel

    attr_accessor :code
    attr_accessor :city_code
    attr_accessor :name
    attr_accessor :latitude
    attr_accessor :longitude
    attr_accessor :address
    attr_accessor :phone_number
    attr_accessor :fax_number
    attr_accessor :price
    attr_accessor :special_offers
    attr_accessor :hotel_amenities
    attr_accessor :room_amenities
    attr_accessor :attractions
    attr_accessor :restaurants
    attr_accessor :rooms
    attr_accessor :reviews
    attr_accessor :rating


    def initialize(
        code            = nil,
        city_code       = nil,
        name            = nil,
        latitude        = nil,
        longitude       = nil,
        address         = nil,
        phone_number    = nil,
        fax_number      = nil,
        price           = nil,
        rating          = nil,
        special_offers  = false,
        hotel_amenities = [],
        room_amenities  = [],
        attractions     = [],
        restaurants     = [],
        rooms           = [],
        reviews         = []
    )
      @code             = code
      @city_code        = city_code
      @name             = name
      @latitude         = latitude
      @longitude        = longitude
      @address          = address
      @phone_number     = phone_number
      @fax_number       = fax_number
      @price            = price
      @rating           = rating
      @special_offers   =special_offers
      @hotel_amenities  = hotel_amenities
      @room_amenities   = room_amenities
      @attractions      = attractions
      @restaurants      = restaurants
      @rooms            = rooms
      @reviews          = reviews

    end

  end

end

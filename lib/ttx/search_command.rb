module TTx
    
    class SearchCommand

        attr_accessor :check_in
        attr_accessor :check_out
        attr_accessor :city_code
        attr_accessor :rooms
        attr_accessor :guest_number
        attr_accessor :room_options
        attr_accessor :hotel_options

        def initialize(check_in = nil, check_out = nil, city_code = nil, rooms = 1, room_options = [], hotel_options = [], guest_number = 1)
          @check_in      = check_in
          @check_out     = check_out
          @city_code     = city_code
          @guest_number  = guest_number
          @room_options  = room_options
          @hotel_options = hotel_options
          @rooms         = rooms
        end

    end 
    
end
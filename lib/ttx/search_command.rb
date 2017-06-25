module TTx
    
    class SearchCommand

        attr_accessor :check_in
        attr_accessor :check_out
        attr_accessor :city_code
        attr_accessor :guest_number

        def initialize(check_in, check_out, city_code, room_options, hotel_options, guest_number = 1)
          @check_in      = check_in
          @check_out     = check_out
          @city_code     = city_code
          @guest_number  = guest_number
          @room_options  = room_options
          @hotel_options = hotel_options
        end

    end 
    
end
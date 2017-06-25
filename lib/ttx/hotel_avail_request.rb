require_relative 'request'

module TTx
    class HotelAvailRequest < Request
        
        def initialize(search_command)
            @search_command = search_command
        end 

        def build

            # here comes the magic
            # return plain xml
        end 

    end
end
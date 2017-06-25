require_relative 'request'
require_relative 'assets'
require 'nokogiri'

module TTx

    class GetHotelImageRequest < Request

        attr_reader :hotel_code, :size

        def initialize(hotel_code, size = 'THUMBNAIL')
            @hotel_code = hotel_code
            @size       = size
        end 

        def build 
            file      = Assets.load_file('get-hotel-image.xml')
            @doc      = Nokogiri::XML::DocumentFragment.parse(file)            
            dummy_ref = @doc.at_xpath('*//*[@HotelCode]')
            parent    = dummy_ref.parent
            
            dummy_ref.remove

            ref                 = Nokogiri::XML::Node.new('HotelRef', @doc)
            ref['HotelCode']    = hotel_code
            ref['CodeContext']  = 'Sabre'
            parent.add_child(ref)

            @doc.to_xml
        end 

        def element
            @doc
        end 
    end 
end
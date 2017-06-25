require 'nokogiri'

require_relative 'request'
require_relative 'assets'


module TTx
    class HotelAvailRequest < Request
        
        def initialize(search_command)
            @search_command = search_command
        end 

        def build
            file      = Assets.load_file('body-avail-hotels.xml')
            @doc      = Nokogiri::XML::DocumentFragment.parse(file)            
            date_node = @doc.at_xpath('*//*[@Start]')
            
            date_node['Start'] = build_sabre_date(@search_command.check_in)
            date_node['End']   = build_sabre_date(@search_command.check_out)

            guess_count_node          = @doc.at_xpath('*//*[@Count]')
            guess_count_node['Count'] = @search_command.guest_number

            hotel_ref_node                  = @doc.at_xpath('*//*[@HotelCityCode]')
            hotel_ref_node['HotelCityCode'] = @search_command.city_code

            criteria = hotel_ref_node.parent

            @search_command.hotel_options.each do |opt|
                # node = Nokogiri::XML::Node.new('', @doc)
                # criteria.add_child()
            end 
            @doc
        end 

        def element
            @doc
        end

        private
            def build_sabre_date(date)
                date.strftime("%m-%d")
            end

    end
end
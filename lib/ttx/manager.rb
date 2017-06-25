require 'nokogiri'
require_relative 'create_session_request'
require_relative 'hotel_avail_request'
require_relative 'get_hotel_image_request'
require_relative 'header_builder'
require_relative 'room_codes'
require_relative 'hotel_builder_helper'

module TTx
    class Manager
        
        SOAP_NAMESPACE = 'http://schemas.xmlsoap.org/soap/envelope/'

        def initialize(security_token = nil, target_url = 'https://sws3-crt.cert.sabre.com/')
            @target_url     = target_url
            @security_token = security_token

        end

        def create_session
            session_req = TTx::CreateSessionRequest.new('803792', 'ws347039', 'F9GE', 'AA', @target_url)
            response    = session_req.send
            extract_session_token(response.body)
        end         

        def get_hotel_avail(search_command) 
            raw_request = build_avail_request(search_command)
            response    = send(raw_request)

            builder      = HotelBuilderHelper.new       
            doc          = Nokogiri::XML(response.body)

            hotels = doc.xpath("//*[@HotelCode]").map  do |element| 
                hotel = builder.build_hotel(element) 
                hotel.image_url = get_image_for(hotel.code, 1)
                if hotel.image_url.nil?
                    index = rand(1..10)
                    hotel.image_url = "https://raw.githubusercontent.com/Nearsoft/sabre-ttx/master/public/img/#{index}.jpg"
                end
                hotel
            end

        end

        def get_image_for(hotel_code, category)
            raw_request = build_get_image_request(hotel_code, category)
            response    = send(raw_request)

            doc = Nokogiri::XML::DocumentFragment.parse(response.body)
            doc.at_xpath('*//*[@Url]')&.attr('Url')
        end 

        private 

            def send(raw_request)
                header  = { 'Content-Type' => "text/xml;charset=UTF-8" }

                uri          = URI.parse(@target_url)
                http         = Net::HTTP.new(uri.host, uri.port) 
                http.use_ssl = true

                http.post(uri.path, raw_request, header)
            end

            def build_get_image_request(hotel_code, category)
                validate_security_token!
                
                request = GetHotelImageRequest.new(hotel_code, category)
                doc     = HeaderBuilder.new('GetHotelImageRQ', @security_token).build_header
                element = Nokogiri::XML::DocumentFragment.parse(request.build)

                doc.at_xpath('*//SOAP-ENV:Body', 'SOAP-ENV': SOAP_NAMESPACE).add_child(element)
                doc.to_xml
            end 

            def build_avail_request(search_command)
                validate_security_token!

                request = HotelAvailRequest.new(search_command)
                doc     = HeaderBuilder.new('OTA_HotelAvailLLSRQ', @security_token).build_header
                element = Nokogiri::XML::DocumentFragment.parse(request.build)

                doc.at_xpath('*//SOAP-ENV:Body', 'SOAP-ENV': SOAP_NAMESPACE).add_child(request.build)
                doc.to_xml
            end 

            def extract_session_token(body)
                doc = Nokogiri::XML(body)
                doc.xpath("//*[@EncodingType]").text
            end

            def validate_security_token!
                if @security_token.nil?
                    raise 'no security_token provided'
                end 
            end

           
    end
end
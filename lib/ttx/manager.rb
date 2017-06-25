require 'nokogiri'
require_relative 'create_session_request'

module TTx
    class Manager
        
        def create_session
            session_req = TTx::CreateSessionRequest.new('124260', 'APPRED17', 'G7RE', 'AA')
            response    = session_req.send

            extract_session_token(response.body)
        end         


        private 
            def extract_session_token(body)
                doc = Nokogiri::XML(body)
                doc.xpath("//*[@EncodingType]").text
            end
    end
end
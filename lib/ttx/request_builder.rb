require_relative 'header_builder'
module TTx
    

    class RequestBuilder
        SOAP_NAMESPACE = 'http://schemas.xmlsoap.org/soap/envelope/'

        def initialize(action_name, security_token, request)
            @doc = HeaderBuilder.new(action_name, security_token).build_header
            @doc.xpath('*//SOAP-ENV:Body', 'SOAP-ENV': SOAP_NAMESPACE).first.content = request.build
        end 
    end 
end
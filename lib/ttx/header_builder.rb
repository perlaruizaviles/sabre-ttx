require 'nokogiri'

require_relative 'assets'

module TTx
    class HeaderBuilder
        EB_NAMESPACE   = 'http://www.ebxml.org/namespaces/messageHeader'
        WSSE_NAMESPACE = 'http://schemas.xmlsoap.org/ws/2002/12/secext'
        attr_reader :action, :security_token

        def initialize(action, security_token)
            @action         = action
            @security_token = security_token
        end

        def build_header 
            file = TTx::Assets.load_file('header.xml')
            doc  = Nokogiri::XML::DocumentFragment.parse(file)

            doc.at_xpath('*//eb:Action', eb: EB_NAMESPACE).child.content                 = @action
            doc.xpath('*//wsse:BinarySecurityToken', wsse: WSSE_NAMESPACE).first.content = @security_token 

            doc
        end
    end 
    
end
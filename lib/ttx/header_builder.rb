require 'nokogiri'

module TTx
    class HeaderBuilder
        attr_reader :action, :security_token

        def initialize(action, security_token)
            @action         = action
            @security_token = security_token
        end

        def build_header 
            File.read()
            Nokogiri::HTML::DocumentFragment.parse()
        end
    end 
    
end
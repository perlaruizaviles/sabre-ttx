require 'net/http'

require_relative 'assets'

module TTx
    class CreateSessionRequest
        attr_reader :username, :password, :org, :domain

        def initialize(username, password, org, domain, target_url)
            @username   = username
            @password   = password
            @org        = org     
            @domain     = domain  
            @target_url = target_url
        end

        def send
            data    = TTx::Assets.load_file('create-session.xml')
            header  = { 'Content-Type' => "text/xml;charset=UTF-8" }

            uri          = URI.parse(@target_url)
            http         = Net::HTTP.new(uri.host, uri.port) 
            http.use_ssl = true

            http.post(uri.path, data, header)
        end 
    end 
end
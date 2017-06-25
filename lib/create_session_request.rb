module TTx

    class CreateSessionRequest
        attr_reader :username, :password, :org, :domain

        def initialize(username, password, org, domain)
            @username = username
            @password = password
            @org      = org     
            @domain   = domain  
        end

        def send
            data    = Manager.new.load
            header  = { 'Content-Type' => "text/xml;charset=UTF-8" }

            uri          = URI.parse('https://sws3-crt.cert.sabre.com/')
            http         = Net::HTTP.new(uri.host, uri.port) 
            http.use_ssl = true

            http.post(uri.path, data, header)
        end 
    end 
end
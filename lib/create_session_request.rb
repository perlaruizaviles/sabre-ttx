module TTx

    class CreateSessionRequest < Request
        def initalize(username, password, org, domain)
            
        end

        def build_request
            data    = Manager.new.load
            header  = { 'Content-Type' => "text/xml;charset=UTF-8" }

            uri          = URI.parse('https://sws3-crt.cert.sabre.com/')
            http         = Net::HTTP.new(uri.host, uri.port) 
            http.use_ssl = true

            result  = http.post(uri.path, data, header)
        end 
    end 
end
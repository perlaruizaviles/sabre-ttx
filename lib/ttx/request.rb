module TTx
    class Request
        attr_accessor :target_url

        def initialize(target_url)
            @target_url = target_url
        end

        def build
            raise 'Not implemented error'
        end 

        def element
            raise 'Not implemented error'
        end 
    end
    
end
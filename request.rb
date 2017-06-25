module TTx
    class Request
        def initialize(url)
            
        end

        def send
        end 

        private 
            def prepare_request
                headers = {
                    content_type: :json, 
                    accept: :json,
                    Authorization: @access_manager.build_auth_token
                }

                request = ::Request.new

                response = RestClient.post(
                    @target_url,
                    request.build_request_for!(search_form),
                    headers
                )

            end 
    end 
end
module Magenthor
    class Base
        @@client = nil
        @@session_id = nil
        @@magento_path = '/api/xmlrpc'
        @@api_user = nil
        @@api_key = nil
        
        #TODO: better description
        #Intializer for setting up connection. Params required: host/port/api_user/api_key
        def initialize params
            if params.class != Hash
                puts "Parameters Error!"
                return false
            end
    
            @@api_user = params[:api_user]
            @@api_key = params[:api_key]
            
            @@client = XMLRPC::Client.new2(url)
            @@client.http_header_extra = { "accept-encoding" => "identity" }
        end
        
        private
        
        def self.login
            @@session_id = @@client.call('login', @@api_user, @@api_key)
        end
        
        def self.logout
            response = @@client.call('endSession', @@session_id)
            @@session_id = nil
            response
        end

        def self.commit resource_path, params
            if params.class == Hash
                params = [params]   #Magento wants an Array, always!
            end
            
            login
            response = @@client.call('call', @@session_id, resource_path, params)
            logout
            response
        end
    end
end
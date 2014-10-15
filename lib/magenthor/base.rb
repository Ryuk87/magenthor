module Magenthor
    class Base
        @@client = nil
        @@session_id = nil
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
            url = "http://#{params[:host]}:#{params[:port]}/api/xmlrpc"
            
            @@client = XMLRPC::Client.new2(url)
            @@client.http_header_extra = { "accept-encoding" => "identity" }
        end
        
        private
        
        #TODO: better description
        def self.login
            begin
                @@session_id = @@client.call('login', @@api_user, @@api_key)
                return true
            rescue => e
                if e.class == NoMethodError
                    puts 'You must first set the connection parameters using Magenthor::Base.new'
                    return false
                end
            end
        end
        
        #TODO: better description
        def self.logout
            response = @@client.call('endSession', @@session_id)
            @@session_id = nil
        end
        
        #TODO: better description
        def self.commit resource_path, params
            if params.class == Hash
                params = [params]   #Magento wants an Array, always!
            end
            
            if login
                begin
                    @@client.call('call', @@session_id, resource_path, params)
                rescue => e
                    if e.class == XMLRPC::FaultException
                        puts "Magento says: #{e.message}"
                    end
                    return false
                ensure
                    logout
                end
            end
        end
    end
end
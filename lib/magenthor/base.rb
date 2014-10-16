# @author Daniele Lenares
module Magenthor
    class Base

        @@client = nil
        @@session_id = nil
        @@api_user = nil
        @@api_key = nil
        

        # Initialize the constants that will be used to make the connection to Magento
        #
        # @param params [Hash] contains the paramters needed for connection
        # @return [Magenthor::Base]
        def self.setup params
            if params.class != Hash
                puts "Parameters must be in an Hash."
                return false
            end

            if !params.key? :host or !params.key? :api_user or !params.key? :api_key
                puts "Mandatory parameter missing. Check if :host, :api_user and :api_key are there."
                return false
            end
    
            @@api_user = params[:api_user]
            @@api_key = params[:api_key]
            url = "http://#{params[:host]}:#{params[:port]}/api/xmlrpc"
            
            @@client = XMLRPC::Client.new2(url)
            @@client.http_header_extra = { "accept-encoding" => "identity" }

            return true
        end
        
        private
        
        # Login to Magento using the parameters setted on #initialize
        #
        # @return [TrueClass, FalseClass] true if login successful or false
        def self.login
            begin
                @@session_id = @@client.call('login', @@api_user, @@api_key)
                return true
            rescue => e
                if e.class == NoMethodError
                    puts 'You must first set the connection parameters using Magenthor::Base.setup'
                    return false
                end
            end
        end
        
        # End the current Magento api session
        def self.logout
            response = @@client.call('endSession', @@session_id)
            @@session_id = nil
        end
        
        # Call the Magento Api resource passing parameters
        #
        # @param resource_path [String] the Magento Api resource path to call
        # @param params [Hash, Array] the paramters needed for the call
        # @return [Array, FalseClass] the result set if the call is successful or false
        def self.commit resource_path, params
            if params.class == Hash
                params = [params]   # Magento wants an Array, always!
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
            else
                return false
            end
        end
    end
end

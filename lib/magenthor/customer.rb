module Magenthor
    class Customer < Base
        
        attr_accessor :firstname, :lastname, :middlename, :increment_id, :store_id, 
                    :website_id, :created_in, :email, :group_id, :prefix, :suffix, :dob,
                    :taxvat, :confirmation, :gender, :password
        attr_reader :customer_id, :increment_id, :created_at, :updated_at, :password_hash
        
        private
        attr_writer :customer_id, :increment_id, :created_at, :updated_at, :password_hash
        
        public
        
        #TODO: better description
        #Initialize a new customer entity
        def initialize params = {}
            params.each do |k, v|
                send("#{k}=", v) if respond_to? "#{k}="
            end
            self.customer_id = params["customer_id"]
            self.increment_id = params["increment_id"]
            self.created_at = params["created_at"]
            self.updated_at = params["updated_at"]
            self.password_hash = params["password_hash"]
            
        end
        
        def update
            attributes = {}
            methods.grep(/\w=$/).each do |m|
                attributes[m.to_s.gsub('=','')] = send(m.to_s.gsub('=',''))
            end
            self.class.commit('customer.update', [self.customer_id, attributes])
        end
        
        def create
            attributes = {}
            methods.grep(/\w=$/).each do |m|
                attributes[m.to_s.gsub('=','')] = send(m.to_s.gsub('=',''))
            end
            response = self.class.commit('customer.create', [attributes])
            return false if response == false

            obj = self.class.find(response)
            methods.grep(/\w=$/).each do |m|
                send(m, obj.send(m.to_s.gsub('=','')))
            end
            self.customer_id = obj.customer_id
            self.increment_id = obj.increment_id
            self.created_at = obj.created_at
            self.updated_at = obj.updated_at
            self.password_hash = obj.password_hash

            return true if response != false
        end

        class << self
            #TODO: better description
            #List al customers with all info
            def list filters = []
                response = commit('customer.list', filters)
                customers = []
                response.each do |r|
                    customers << find(r["customer_id"])
                end
                return customers
            end
            
            #TODO: better description
            #Find a customer by id
            def find customer_id
                response = commit('customer.info', [customer_id])
                new(response) unless response == false
            end
            
            #TODO: better description
            #Dynamic methods to find customers based on Magento attributes
            customer_attributes = [
                "increment_id",
                "created_in",
                "store_id",
                "website_id",
                "email",
                "firstname",
                "middlename",
                "lastname",
                "group_id",
                "prefix",
                "suffix",
                "dob",
                "taxvat",
                "confirmation"]
            customer_attributes.each do |a|
                define_method("find_by_#{a}") do |arg|
                    find_by a, arg
                end
            end

            
            private
            
            #TODO: better description
            #Method to find customers based on a specific Magento attribute
            def find_by (attribute, value)
                response = commit('customer.info', [attribute => value])
                new(response) unless response == false
            end
        end
    end
end

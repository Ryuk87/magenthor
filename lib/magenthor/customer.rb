# @author Daniele Lenares
module Magenthor
    class Customer < Base
        
        attr_accessor :firstname, :lastname, :middlename, :increment_id, :store_id, 
                    :website_id, :created_in, :email, :group_id, :prefix, :suffix, :dob,
                    :taxvat, :confirmation, :gender, :password
        attr_reader :customer_id, :increment_id, :created_at, :updated_at, :password_hash
        
        private
        attr_writer :customer_id, :increment_id, :created_at, :updated_at, :password_hash
        
        public
        
        # Initialize a new Customer entity
        #
        # @param params [Hash] the to save in the instance on initialization
        # @return [Magenthor::Customer] a new instance of Customer
        def initialize params = {}
            methods.grep(/\w=$/).each do |m|
                send(m, nil)
            end
            params.each do |k, v|
                send("#{k}=", v) if respond_to? "#{k}="
            end
            self.customer_id = params["customer_id"]
            self.increment_id = params["increment_id"]
            self.created_at = params["created_at"]
            self.updated_at = params["updated_at"]
            self.password_hash = params["password_hash"]
            
        end
        
        # Save on Magento the updates on the local Customer
        #
        # @return [TrueClass, FalseClass] true if successful or false
        def update
            attributes = {}
            methods.grep(/\w=$/).each do |m|
                attributes[m.to_s.gsub('=','')] = send(m.to_s.gsub('=',''))
            end
            self.class.commit('customer.update', [self.customer_id, attributes])
        end

        # Create on Magento the local Customer
        #
        # @return [TrueClass, FalseClass] true if successful or false
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

            return true
        end

        # Remove from Magento the local Customer
        #
        # @return [TrueClass, FalseClass] true if successful or false
        def delete
            response = self.class.commit('customer.delete', [self.customer_id])
            return false if response == false

            methods.grep(/\w=$/).each do |m|
                send(m, nil)
            end
            self.customer_id = nil
            self.increment_id = nil
            self.created_at = nil
            self.updated_at = nil
            self.password_hash = nil

            return true
        end

        class << self

            # Retrieve the list of all Magento customers with or without filters
            #
            # @param filters [Array] the filters by customer attributes
            # @return [Array<Magenthor::Customer>, FalseClass] the list of all customers as Customer entities or false
            def list filters = []
                response = commit('customer.list', filters)
                return false if response == false
                customers = []
                response.each do |r|
                    customers << find(r["customer_id"])
                end
                return customers
            end
            
            # Find a specific Customer by Magento ID
            #
            # @param customer_id [String, Integer] the id of the customer to retrieve
            # @return [Magenthor::Customer, FalseClass] the customer entity or false if not found
            def find customer_id
                response = commit('customer.info', [customer_id])
                new(response) unless response == false
            end
            
            # Magento Customer Attributes
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
                # Dynamic methods to find customers based on Magento attributes
                define_method("find_by_#{a}") do |arg|
                    list({a.to_sym => arg})
                end
            end

            # Get the list of all Magento customer groups
            #
            # @return [Array, FalseClass] the list of all customer groups or false
            def groups
                commit('customer_group.list',  [])
            end

        end
    end
end

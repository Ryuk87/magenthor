module Magenthor
    class Customer < Base
        class << self
            #TODO: better description
            #List al customers
            def list filters = []
                response = commit('customer.list', filters)
            end
            
            #TODO: better description
            #Find a customer by id
            def find customer_id
                response = commit('customer.info', [customer_id])
            end
            
            #TODO: better description
            #Dynamic methods to find customers based on Magento attributes
            customer_attributes = [
                "created_at",
                "updated_at",
                "increment_id",
                "store_id",
                "website_id",
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
                "confirmation",
                "password_hash",
                "rp_token",
                "rp_token_created_at"]
            customer_attributes.each do |a|
                define_method("find_by_#{a}") do |arg|
                    find_by a, arg
                end
            end
            
            #TODO: better description
            #Create a new customer
            def create attributes
                response = commit('customer.create', attributes)
            end
            
            
            
            private
            
            #TODO: better description
            #Method to find customers based on a specific Magento attributes
            def find_by (attribute, value)
                response = commit('customer.info', [attribute => value])
            end
        end
    end
end
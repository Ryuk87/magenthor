# @author Daniele Lenares
module Magenthor
    class Product < Base

        attr_reader :product_id
        private
        attr_writer :product_id

        public

        # Initialize a new product entity based on an attribute set id
        #
        # @param set_id [Integer, String] the attribute set of the new product
        # @return [Magenthor::Product] the empty product
        def initialize set_id
            attributes = Magenthor::Catalog.attribute_list set_id
            attributes.each do |attr|
                if attr["code"] != 'product_id' and attr["code"] != 'created_at'
                    singleton_class.class_eval do; attr_accessor attr["code"]; end
                    send(attr["code"]+"=", nil)
                end
            end
            singleton_class.class_eval do; attr_accessor "type"; end
            singleton_class.class_eval do; attr_accessor "set"; end
            self.set = set_id
            self.type = nil
            self.product_id = nil
        end

        # Save on Magento the updates made on the local product
        #
        # @return [TrueClass, FalseClass] true if successful or false
        def update
            attributes = {}
            methods.grep(/\w=$/).each do |m|
                attributes[m.to_s.gsub('=','')] = send(m.to_s.gsub('=',''))
            end
            self.class.commit('catalog_product.update', [self.product_id, attributes])
        end

        # Create on Magento a new product base on the local one
        #
        # @return [TrueClass, FalseClass] true if successful or false
        def create
            if self.type.nil? or self.set.nil? or self.sku.nil?
                puts "Type, set and sku are mandatory"
                return false
            end
            attributes = {}
            methods.grep(/\w=$/).each do |m|
                value =  send(m.to_s.gsub('=',''))
                attributes[m.to_s.gsub('=','')] = value unless value.nil?
            end
            response = self.class.commit('catalog_product.create', [self.type, self.set, self.sku, attributes])
            return false if response == false
            obj = self.class.info response
            methods.grep(/\w=$/).each do |m|
                send(m, obj.send(m.to_s.gsub('=','')))
            end
            self.product_id = obj.product_id
            return true
        end

        # Delete from Magento the local product
        #
        # @return [TrueClass, FalseClass] true if successful or false
        def delete
            response = self.class.commit('catalog_product.delete', [self.product_id])
            return false if response == false

            methods.grep(/\w=$/).each do |m|
                send(m, nil)
            end
            self.product_id = nil

            return true
        end

        class << self

            # Retrieve the list of Magento product based on filters and store view
            #
            # @param filters [Array] array of filters by attributes
            # @param store_view [String, Integer] Magento store view ID or code
            # @return [Array<Magenthor::Product>] the list of products entities matching the search
            def list filters = [], store_view = ''
                response = commit('catalog_product.list', [filters, store_view])
                return false if response == false
                products = []
                response.each do |p|
                    products << Magenthor::Product.info(p["product_id"], store_view)
                end
                return products
            end

            # Retrieve the information about a specific product
            #
            # @param product_id [String, Integer] the id of the product to get
            # @param store_view [String, Integer] Magento store view ID or code
            # @return [Magenthor::Product] the product entity searched
            def info product_id, store_view = ''
                response = commit('catalog_product.info', [product_id, store_view])
                return false if response == false
                obj = new response["set"]
                response.each do |key, value|
                    obj.class.class_eval do; attr_accessor key; end unless obj.respond_to?(key)
                    obj.send(key+"=", value)
                end
                return obj
            end

        end
    end
end

# @author Daniele Lenares
module Magenthor
    class Catalog < Base

        class << self
            # Get the list of all products sets
            #
            # @return [Array, FalseClass] a list of all attribute sets or false
            def attribute_set_list
                commit('catalog_product_attribute_set.list', [])
            end

            # Get the list of a attribute set
            #
            # @param set_id [String, Integer] the set id to get the attributes from
            # @return [Array, FalseClass] a list of all attributes of the set or false
            def attribute_list set_id
                commit('catalog_product_attribute.list', [set_id])
            end

            # Get the list of all additional attributes
            #
            # @param product_type [String] the type of the product
            # @param set_id [String, Integer] the attribute set id
            # @return [Array, FalseClass] a list of all additional attributes or false
            def additional_attribute_list product_type, set_id
                commit('product.listOfAdditionalAttributes', [product_type, set_id])
            end
        end

    end
end

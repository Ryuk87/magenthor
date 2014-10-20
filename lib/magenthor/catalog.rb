# @author Daniele Lenares
module Magenthor
    class Catalog < Base

        class << self
            # Get the list of all products sets
            #
            # @return [Array] a list of all attribute sets
            def attribute_set_list
                commit('catalog_product_attribute_set.list', [])
            end

            # Get the list of a attribute set
            #
            # @param set_id [String, Integer] the set id to get the attributes from
            # @return [Array] a list of all attributes of the set
            def attribute_list set_id
                commit('catalog_product_attribute.list', ["setId" => set_id])
            end
        end

    end
end

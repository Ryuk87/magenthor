# @author Daniele Lenares
require "magenthor/version"
require "magenthor/base"
require "xmlrpc/client"

XMLRPC::Config.send(:remove_const, :ENABLE_NIL_PARSER)
XMLRPC::Config.send(:const_set, :ENABLE_NIL_PARSER, true)
XMLRPC::Config.send(:remove_const, :ENABLE_NIL_CREATE)
XMLRPC::Config.send(:const_set, :ENABLE_NIL_CREATE, true)

module Magenthor
    autoload :Customer, 'magenthor/customer'
    autoload :Catalog, 'magenthor/catalog'
    autoload :Product, 'magenthor/product'
end

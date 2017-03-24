#!/usr/bin/env lua5.1

package.path = ';lua/?.lua;' .. package.path

lide  = require 'lide.core.init'
error = require 'lide.error.init' 

assert(lide.core.lua.type(error) == 'table', 'No se pudo cargar el modulo')
assert(lide.core.lua.type(try)   == 'function', 'La funcion try no se encuentra como valor global.')
assert(lide.core.lua.type(catch)   == 'function', 'La funcion catch no se encuentra como valor global.')
assert(lide.core.lua.type(finally)   == 'function', 'La funcion finally no se encuentra como valor global.')


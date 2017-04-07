#!/usr/bin/env lua5.1

-- /////////////////////////////////////////////////////////////////////////////////////////////////
-- // Name:        tests/init_test.lua
-- // Purpose:     Tests file
-- // Author:      Dario Cano [dario.canohdz [at] gmail.com]
-- // Created:     2017/04/07
-- // Copyright:   (c) 2017 Dario Cano
-- // License:     MIT License/X11 license
-- /////////////////////////////////////////////////////////////////////////////////////////////////

package.path = ';lua/?.lua;' .. package.path

lide  = require 'lide.core.init'
error = require 'lide.error.init' 

assert(lide.core.lua.type(error) == 'table', 'No se pudo cargar el modulo')
assert(lide.core.lua.type(try)   == 'function', 'La funcion try no se encuentra como valor global.')
assert(lide.core.lua.type(catch)   == 'function', 'La funcion catch no se encuentra como valor global.')
assert(lide.core.lua.type(finally)   == 'function', 'La funcion finally no se encuentra como valor global.')
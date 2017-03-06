package.path = ';?.lua;?/init.lua;'

-- import creates a base Error class and global funcs try(), catch(), finally()

-- create custom error class
-- this class could be more complex,
-- but this is all we need for a custom error
error = require 'init' 

--error ('Error con el string')


--[[
local TypeError = Error . newException 'TypeError'
local FileError = Error . newException 'FileError'

-- raise an error
function foo( a )
--   lide.core.base.isboolean(a)
   error (TypeError 'bad type, must be string.')
end

try {
	function ()
    	-- make a call which could raise an error
    	foo (1)
  	end,

  	catch {
    	function( err )
         if type(err) == 'string' then
            print(err)
         elseif err:isa(TypeError) then
      	   print(err)
         end
    	end
  	},

  	finally{
    	function()
      		-- do some cleanup
    	end
  	}
}]]
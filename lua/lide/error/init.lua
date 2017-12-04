assert( class or lide.class, "liderror: requires lide.class" )

local ltrace = require 'lide.error.ltrace'

--====================================================================--
--== Setup, Constants

local DEFAULT_PREFIX     = "ERROR: "
local DEFAULT_MESSAGE    = "LuaException"
local DEFAULT_STACKLEVEL = 3
local REM_NUM_STACKS     = 4

--====================================================================--
--== Support Functions

-- based on https://gist.github.com/cwarden/1207556

local function try( funcs )
	local try_f, catch_f, finally_f = funcs[1], funcs[2], funcs[3]
	assert( try_f, "lua-error: missing function for try()" )
	
	REM_NUM_STACKS = 6
	
	local status, result = pcall(try_f)
	if not status and catch_f then
		catch_f(result)
	end
	if finally_f then finally_f() end
	return result
end

local function catch(f)
	return f[1]
end

local function finally(f)
	REM_NUM_STACKS = nil
	return f[1]
end

--====================================================================--
--== Error Base Class
--====================================================================--

local Error = class 'Error' : subclassof ( Object )

local DEFAULT_ERROR_NAME = Error:name()

Exception = class 'Exception' : subclassof ( Object )

function Exception:Exception ( sExceptionName )
   public {
   	message = DEFAULT_MESSAGE,
   	traceback = '',
   	--prefix  = params.prefix or DEFAULT_PREFIX,
	}

	private {
   		name   = sExceptionName or DEFAULT_ERROR_NAME,
   		values = {}
	}

   self.super : init (self.name)
end

function Exception:__call ( message, nlevel )	
	self.nlevel       = nlevel or DEFAULT_STACKLEVEL
	
	local maxstack    = (#ltrace.getstack(self.nlevel) - REM_NUM_STACKS)
	
	self.message   = 'TypeException: ' .. (message or self.message)
	self.traceback = self.message ..'\n\n'.. ltrace.getfulltrace(self.nlevel, maxstack)
	
	lide.core.lua.error (self)
end

function Exception:__tostring( ... )
	return self.traceback
end

function Exception:isa ( ExceptionObject )
	return self:getName() == ExceptionObject:getName()
end

function Error:Error ( message, nlevel )
	
	public { 
		message = message or DEFAULT_MESSAGE,
		nlevel  = nlevel or DEFAULT_STACKLEVEL
	}
	
	self . super :init 'LideException'
	
	lide.core.lua.error(self.message, self.nlevel)
end

function Error:__tostring( ... )
	return table.concat( { self.message, "\n", self.traceback } )
end

local TypeException = Exception :new 'TypeException'


local function istype( ValueToCompare, TypeToCompare )
	local errmsg = errmsg or ('type is incorrect, must be %s.'):format(TypeToCompare)
	
	if lide.core.base.type(ValueToCompare) == TypeToCompare then 
		return ValueToCompare 
	else 
		if not errmsg then 
			return false ;
		else 
			TypeException(errmsg, DEFAULT_STACKLEVEL +1);
		end 
	end
end

Error : enum { 
	newException = function ( sExceptionName )
   	local newException = Exception :new ( sExceptionName )

   	return newException
	end ,

	DEFAULT_STACKLEVEL = DEFAULT_STACKLEVEL,

	TypeException = TypeException,

	is_number = function ( value, errmsg )
		return istype(value, 'number');
	end,

	is_string = function ( value, errmsg )
		return istype(value, 'string');
	end,

	is_function = function ( value, errmsg )
		return istype(value, 'function');
	end,

	is_object = function ( value, errmsg )
		return istype(value, 'object');
	end,

	is_boolean = function ( value, errmsg )
		return istype(value, 'boolean');
	end,

	is_table = function ( value, errmsg )
		return istype(value, 'table');
	end,
}

--====================================================================--
--== Error API Setup
--====================================================================--

-- globals
_G.try = try
_G.catch = catch
_G.finally = finally

getmetatable(Error).__tostring = function ( ... )
	return '[lide.error] namespace' 
end

return Error
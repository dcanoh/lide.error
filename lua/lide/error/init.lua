assert( class or lide.class, "liderror: requires lide.class" )

--local lua = { error = error }

--====================================================================--
--== Setup, Constants

local DEFAULT_PREFIX     = "ERROR: "
local DEFAULT_MESSAGE    = "LuaException"

--====================================================================--
--== Support Functions

-- based on https://gist.github.com/cwarden/1207556


local function try( funcs )
	local try_f, catch_f, finally_f = funcs[1], funcs[2], funcs[3]
	assert( try_f, "lua-error: missing function for try()" )
	--==--
	
	lide.try_level = 6

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
	return f[1]
end

--====================================================================--
--== Error Base Class
--====================================================================--

local Error = class 'Error' : subclassof 'Object' : global ( false )

local DEFAULT_ERROR_NAME = Error:name()

local lperr

---- lide print error
lperr = function ( sErrMsg, nlevel )
		local short_src
		
		lide.core.base.isstring(sErrMsg)
		

		nlevel = nlevel or 1
		-- levels { 
		--	 1 = the function itself
		-- 	 2 = error dispatcher
		--   3 = caller of error_dispacher()
		--   4 = caller of 3
		--	 ..= main()
		-- }	
		local print_ok = true
		
		local function print( ... )
			io.stderr:write( tostring(unpack{...} or '') .. '\n')
		end
		
		--local err_msg = ('Lide, Error: %s\n\n'):format(sErrMsg)
		local err_msg = ''
		
		local tmp_file_src = '' -- Esto es para que todos los levels continuos se junten:
		-- [/fs/ss/loo.lua]
		-- [line:1] dadasdsada
		-- [line:104] dadasdsada
		--
		-- Comienza desde 2: "la funcion que genera el error":
		-- repeat nlevel  = nlevel +1 (...)
		local traceback = ''
		local i = nlevel repeat i = i +1
			local level = debug.getinfo(i)
			if level then
				local short_src   = tostring(level.short_src or 'NULL_FILE')
				local currentline = tonumber(level.currentline or -3) --> -3 simplemnte es para identificar que es un error, este numero no tiene nada que ver con nada.
				local namewhat    = tostring(level.namewhat or 'NULL_NAMEWHAT')
				local name        = tostring(level.name or 'NULL_NAME')
				local print_line  = true

				if level.what == 'main' then
					name     = 'main'
					namewhat = 'chunk'
				end
				
				if name == 'NULL_NAME' or name == 'NULL_NAME ' and level.what == 'main' then
					name = '..main chunk..'
					print_line = false
				end
				
				if currentline == -1 and name == 'pcall' then
					print_line = false
				end

				if short_src == '[string ""]' then
					--print(namewhat)
					--print(name)
					--print(currentline)
					print_line = false
				end



				if (namewhat == 'global') and (type(level.func) == 'function') then
					namewhat = 'global function definition'
				elseif (namewhat == 'upvalue') or (namewhat == 'local') and (type(level.func) == 'function') then
					namewhat = 'local function definition'
				elseif (namewhat == 'method') and ( name == 'init' ) and (type(level.func) == 'function') then
					local _, self = debug.getlocal(i, 1) -- get 'self'
					name = 'constructor '
					namewhat = ('definition of "%s"'):format(tostring(self:class() or ''))
				elseif (namewhat == 'method') and (type(level.func) == 'function') then
					local _, self, class_name = debug.getlocal(i, 1) -- get 'self'
					
					if self and getmetatable(self) and getmetatable(self).__lideobj and not self.getName 
						and type(getmetatable(self).__index) == 'table' then 
						local class_name = getmetatable(self).__index.name()
						if  getmetatable(self).__lideobj and getmetatable(self).__type == 'class' then						
							print_line = false --> no imprimir estalinea en el traceback --[./lide/core/oop/yaci.lua]
						end
					else
						if self and getmetatable(self) and getmetatable(self).__lideobj and getmetatable(self).__type ~= 'class' then
							-- Obtenemos el nombre de la clase desde yaci:
							class_name = self:class():name()
						end
					end
					namewhat = ('method of "%s" object'):format(class_name or '')
				end

				if print_line then
					if (tmp_file_src ~= short_src) then 
						traceback = (traceback .. '[%s]\n' ):format(short_src)
					end
					traceback = traceback.. ('[line:%d] in %s %s.\n'):format(currentline, name, namewhat)
				end
			end			
			tmp_file_src = short_src ;
		until not debug.getinfo(i) or debug.getinfo(i).what == 'main'

		return (err_msg .. traceback) --os.exit()
end


Exception = class 'Exception' : subclassof 'Object' : global ( false )

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
	self.nlevel    = nlevel or lide.try_level or 2
	
	self.message   = message or self.message
	self.traceback = lperr (self.message, self.nlevel)
	
	lide.core.lua.error (self, self.nlevel)

	--return self
end

function Exception:__tostring( ... )
	return table.concat( { self.message, "\n", self.traceback } )
end

function Exception:isa ( ExceptionObject )
	return self:getName() == ExceptionObject:getName()
end

function Error:Error ( message, nlevel )
	--params = params or {}
	
	public { 
		message = message or DEFAULT_MESSAGE,
		nlevel = nlevel or 1
	}
	
	self . super :init 'LideException'
	
	lide.core.lua.error(self.message, self.nlevel)
end

--function Error:getExceptionName( ... )
--	return self.__exception
--end

-- must return a string
--
---Error:virtual '__tostring'
function Error:__tostring( ... )
	return table.concat( { self.message, "\n", self.traceback } )
end

Error : enum { 
	newException = function ( sExceptionName )
   	local newException = Exception :new ( sExceptionName )

   	return newException
	end ,

	--Exception = Exception
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
lide.error
==========

.. code-block::

 author : Hernan Dario Cano
 version: 0.0.01


================  =================  =========
  platform          arch              build
================  =================  =========
  ``GNU/Linux``    ``x64``             .. image:: https://circleci.com/gh/dcanoh/lide.error.svg?style=svg
  ``Windows``      ``x86`` ``x86``     .. image:: https://ci.appveyor.com/api/projects/status/1902m5k8094gp7vy/branch/master  
                                        :target: https://ci.appveyor.com/project/dcanoh/lide-error
================  =================  =========

**Caracteristicas:**

* Manejo de expeciones
* Funciones try, catch, finally
* Creacion de nuevas excepciones y clases de error
* No depende de otras librerias

----------------------------------------------------------------------------------------------------

Liderror es una robusta librería que contiene funciones y herramientas específicas para el manejo de errores y excepciones en lua.

Facilita el proceso de depuración permitiendo la implementación de nuevas excepciones y utiliza un sistema de manejo de errores inspirado en Python, usted podrá depurar su código de una forma más intuitiva.

Usted puede intentar ejecutar una pieza de código que se supone que tendrá un error y controlar la propagación del error.

.. code-block:: lua

 -- import creates a base Error class and global funcs try(), catch(), finally()

 local Error = require 'liderror'

 -- do this anywhere in your code:

 try{
   function()
     -- make a call which could raise an error
   end,

   catch{
     function( err )
       -- handle the error
     end
   },

   finally{
     function()
       -- do some cleanup
     end
   }
 }

  Nótese que ``catch{}`` y ``finally{}`` son opcionales.

- **try:**  Dentro de ésta función pondremos la pieza de código que podría tener error.
- **catch:** Dentro de esta función pondremos el código que se ejecutará en caso de error.
- **finally:** Aquí deberíamos poner código de limpieza

Con esto podemos estar tranquilos de que si se produce algún error vamos a poder investigar acerca de eso y que vamos a tener un mensaje correspondientemente.

Creación y manejo de excepciones:
*********************************

También es posible ser más preciso y dar con el tipo de error que estamos buscando, para eso están las excepciones.

Podemos crear nuevas excepciones y controlarlas con la funcion catch.

.. code-block:: lua

 local Error = require 'liderror'
 
 local TypeError = Error.newException 'TypeError'

 try{
    function()
        function foo(text)
            if type(text) ~= 'string' then
               TypeError '"text" No es del tipo string'
            end
        end

        foo(1) -- Ejecutamos la funcion con un numero como argumento para que se propague nuestro error.
    end,

 catch {
    function( err )
        if err:isa(TypeError) then -- Utilizamos el metodo "isa" para comparar que tipo de error/excepcion es.
           print(err.traceback)
        end
    end
   }
 }


La libreria liderror utiliza los objetos ``Error`` y ``Exception`` para funcionar, usted podrá tambien
crear sus propias excepciones para controlar mejor la ejecución de su código o utilizar las que estén 
creadas ya.

Para aprender más sobre el manejo de expeciones con liderror, se recomienda leer la documentación
completa de la API de excepciones.

----------------------------------------------------------------------------------------------------

> `Ver API de excepciones <exceptions.rst # api-de-excepciones>`_

----------------------------------------------------------------------------------------------------
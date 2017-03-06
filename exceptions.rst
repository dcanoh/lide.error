API de Excepciones
==================

> `Read in English <exceptions_en.rst>`_

------------------------------------------------------------------------------------------------------------------

Cuando cargamos el modulo 'liderror' en nuestro entorno lua se importa la tabla de la libreria en la
cual encontraremos la api de manejo de errores, también se registran las palabras clave ``try``, 
``catch`` y ``finally`` en el entorno global o ``_G``.

.. code-block:: lua

 error = require 'liderror'

====================  ===========  ===============================================================================
  Field                 Type         Descripción
====================  ===========  ===============================================================================
 error.newException    function_    Crear una nueva excepcion
 error.try             function_    Dentro de ésta función pondremos la pieza de código que podría tener error.
 error.catch           function_    ``Opcional`` Dentro de esta función pondremos el código que se ejecutará en caso de error.
 error.finally         function_    ``Opcional`` Aquí deberíamos poner código de limpieza
 error.Exception       class_       Clase Exception, padre de todas las excepciones.
 error.Error           class_       Clase Error, componente base.
====================  ===========  ===============================================================================

error.newException
^^^^^^^^^^^^^^^^^^
   
Crear una nueva excepción.

============  ========================================================================================
 Exception_     error.newException ( string_ ExceptionName )
============  ========================================================================================



.. // Required values for html docs visualization
.. _function:   http://lide-framework.readthedocs.io/types.html # function-type
.. _class:      http://lide-framework.readthedocs.io/types.html # class-type
.. _string:     http://lide-framework.readthedocs.io/types.html # string-type

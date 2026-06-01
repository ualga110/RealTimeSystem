package Recursos is

   -- Recurso 1: Tarjeta A/D
   -- Accedida por las tres tareas para leer sensores.
   protected Tarjeta_AD is
      pragma Priority (3);
      procedure Usar;
   end Tarjeta_AD;

   -- Recurso 2: Visualizacion por pantalla
   -- Accedida por las tres tareas para mostrar informacion.
   protected Pantalla is
      pragma Priority (3);
      procedure Mostrar (Mensaje : String);
   end Pantalla;

   -- Recurso 3: Almacenamiento de datos
   -- Accedida por CCS y CMD para guardar medidas.
   protected Almacenamiento is
      pragma Priority (2);
      procedure Guardar (Mensaje : String);
   end Almacenamiento;

end Recursos;

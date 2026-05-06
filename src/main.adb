procedure Main is

begin

   -- Bucle infinito del procedimiento cíclico secuencial

   loop

      -- El orden de ejecucion viene dado por el criterio y el periodo establecidos


      -- 1. Se ejecuta la tarea con mayor nivel de prioridad (Prevencion de daños)
      Sistema_Seguridad;

      -- 2. Se ejecuta tarea nivel de prioridad medio (Control de la energia)
      Control_Campo_Solar;

      --3. Ejecutamos la tarea de menor prioridad (Produccion)
      Control_Modulo_MD;


   end loop;
end Main;

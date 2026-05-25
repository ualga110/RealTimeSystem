-- recursos.ads
-- Especificacion del paquete Recursos.
-- Define los tres recursos compartidos del sistema como objetos
-- protegidos (protected objects) de Ada.
--
-- El uso de objetos protegidos garantiza exclusion mutua automatica:
-- cuando una tarea esta dentro de un procedimiento protegido, ninguna
-- otra puede entrar. Esto implementa de forma natural el protocolo
-- de techo de prioridad inmediato (Immediate Priority Ceiling Protocol)
-- cuando se especifica la prioridad del objeto protegido con pragma
-- Priority, evitando inversiones de prioridad indeseadas.

package Recursos is

   -- Recurso 1: Tarjeta A/D
   -- Accedida por las tres tareas para leer sensores.
   -- Techo de prioridad = maxima prioridad de las tareas que la usan = 3
   protected Tarjeta_AD is
      pragma Priority (3);
      procedure Usar;
   end Tarjeta_AD;

   -- Recurso 2: Visualizacion por pantalla
   -- Accedida por las tres tareas para mostrar informacion.
   -- Techo de prioridad = 3
   protected Pantalla is
      pragma Priority (3);
      procedure Mostrar (Mensaje : String);
   end Pantalla;

   -- Recurso 3: Almacenamiento de datos
   -- Accedida por Solar y MD para guardar medidas.
   -- Techo de prioridad = maxima prioridad entre Solar (P=2) y MD (P=1) = 2
   protected Almacenamiento is
      pragma Priority (2);
      procedure Guardar (Mensaje : String);
   end Almacenamiento;

end Recursos;

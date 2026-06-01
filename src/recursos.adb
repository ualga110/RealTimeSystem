with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Real_Time;  use Ada.Real_Time;

package body Recursos is

   -- Tiempo de computo de cada subtarea al acceder a un recurso
   Tc : constant Time_Span := Milliseconds (8);

   -- Tarjeta A/D
   protected body Tarjeta_AD is

      procedure Usar is
         Fin : Time := Clock + Tc;
      begin
         -- El acceso a la seccion protegida garantiza que ninguna otra
         -- tarea puede usar simultaneamente la tarjeta A/D.
         delay until Fin;
      end Usar;

   end Tarjeta_AD;

   -- Pantalla
   protected body Pantalla is

      procedure Mostrar (Mensaje : String) is
         Fin : Time := Clock + Tc;
      begin
         -- La exclusion mutua evita que los mensajes de distintas tareas
         -- se mezclen en la salida por pantalla.
         Put_Line (Mensaje);
         delay until Fin;
      end Mostrar;

   end Pantalla;

   -- Almacenamiento
   protected body Almacenamiento is

      procedure Guardar (Mensaje : String) is
         Fin : Time := Clock + Tc;
      begin
         Put_Line ("[AD] " & Mensaje);
         delay until Fin;
      end Guardar;

   end Almacenamiento;

end Recursos;

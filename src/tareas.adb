with ADA.Text_IO; use ADA.Text_IO;

package body tareas is

   protected body Pantalla is

      -- Recurso compartido

      procedure Escribir (Mensaje : in String) is
      begin
         for i in Mensaje'Range loop
         Ada.Text_IO.Put(Mensaje(i));
         delay 0.001;
      end loop;

      end Escribir;

   end Pantalla;


   -- Tarea 1

   task body Sistema_Seguridad is
   begin
      loop
         Pantalla.Escribir("SS - Solicitud de lectura a tarjeta A...");

         Pantalla.Escribir("SS - Comprobar límites de seguridad (T < 95 ºC)...");

         Pantalla.Escribir("SS - Enviando estado a la Pantalla (VP) ...");


         Pantalla.Escribir("SS - Registro de alarmas en la Almacenamiento de Datos....");

      end loop;
   end Sistema_Seguridad;

   -- Tarea 2

   task body Control_Campo_Solar is
      begin
      loop

         Pantalla.Escribir("CCS - Lectura de sensores de radiación y temperatura...");


         Pantalla.Escribir("CCS - Calculo acción de control....");


         Pantalla.Escribir("CCS - Escribiendo en actuador mediante A/D....");


         Pantalla.Escribir("CCS - Envío telemetría a la Pantalla (VP)....");


         Pantalla.Escribir("CCS - Registro de datos en la AD...");


         end loop;
   end Control_Campo_Solar;

   -- Tarea 3

   task body Control_Modulo_MD is
     begin
      loop

          Pantalla.Escribir("CMD - Lectura sensores de flujo del modelo....");

          Pantalla.Escribir("CMD - Calculo caudal requerido (SC2)...");


          Pantalla.Escribir("CMD - Escritura en actuador mediante A/D");

          Pantalla.Escribir("CMD - Envío telemetría a la Pantalla (VP)....");

          Pantalla.Escribir("CMD - Registro de datos en la AD...");

        end loop;

   end Control_Modulo_MD;

end tareas;

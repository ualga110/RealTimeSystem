with Ada.Text_IO; use Ada.Text_IO;

package body Tareas is

   task body Pantalla_VP is
   begin
      loop
         select
            when Mostrar_SS'Count > 0 =>
               accept Mostrar_SS(Msg : in String) do
                  for i in Msg'Range loop
                     Put(Msg(i));
                  end loop;
                  New_Line;
               end Mostrar_SS;
         or
            when Mostrar_SS'Count = 0 =>
               accept Mostrar_CCS(Msg : in String) do
                  for i in Msg'Range loop
                     Put(Msg(i));
                  end loop;
                  New_Line;
               end Mostrar_CCS;
         or
            when Mostrar_SS'Count = 0 =>
               accept Mostrar_CMD(Msg : in String) do
                  for i in Msg'Range loop
                     Put(Msg(i));
                  end loop;
                  New_Line;
               end Mostrar_CMD;
         end select;
      end loop;
   end Pantalla_VP;

   task body Lector_AD is
   begin
      loop
         select
            when Leer_SS'Count > 0 =>
               accept Leer_SS do
                  Pantalla_VP.Mostrar_SS("AD - Leyendo temperatura SS (ST2)...");
               end Leer_SS;
         or
            when Leer_SS'Count = 0 =>
               accept Leer_CCS do
                  Pantalla_VP.Mostrar_CCS("AD - Leyendo sensores CCS (ST1, ST2, ST4, SR1)...");
               end Leer_CCS;
         or
            when Leer_SS'Count = 0 =>
               accept Leer_CMD do
                  Pantalla_VP.Mostrar_CMD("AD - Leyendo sensores CMD (ST2, ST3)...");
               end Leer_CMD;
         end select;
      end loop;
   end Lector_AD;

   task body Escritor_AD is
   begin
      loop
         select
            accept Escribir_SC1 do
               Pantalla_VP.Mostrar_CCS("AD - Escribiendo SC1 en Bomba1...");
            end Escribir_SC1;
         or
            accept Escribir_SC2 do
               Pantalla_VP.Mostrar_CMD("AD - Escribiendo SC2 en Bomba2...");
            end Escribir_SC2;
         end select;
      end loop;
   end Escritor_AD;

   protected body Almacenamiento_Datos is
      procedure Registrar(Datos : in String) is
      begin
         null;
      end Registrar;
   end Almacenamiento_Datos;

   task body Sistema_Seguridad is
   begin
      loop
         Pantalla_VP.Mostrar_SS("SS - Solicitud de lectura de tarjeta A/D...");
         Lector_AD.Leer_SS;
         Pantalla_VP.Mostrar_SS("SS - Lectura de entrada del modulo y la salida de temperatura del campo (ST2)...");
         Pantalla_VP.Mostrar_SS("SS - Comprobacion niveles de seguridad (T < 95 C)...");
         Pantalla_VP.Mostrar_SS("SS - Enviando estado a la Visualizacion por Pantalla (VP)...");
         Pantalla_VP.Mostrar_SS("SS - Registro alarmas en el Almacenamiento de Datos (AD)...");
         Almacenamiento_Datos.Registrar("SS - Registro alarmas en AD");
      end loop;
   end Sistema_Seguridad;

   task body Control_Campo_Solar is
   begin
      loop
         Pantalla_VP.Mostrar_CCS("CCS - Solicitud lectura de tarjeta A/D...");
         Lector_AD.Leer_CCS;
         Pantalla_VP.Mostrar_CCS("CCS - Lectura de sensores (ST1, ST2, ST4, SR1)...");
         Pantalla_VP.Mostrar_CCS("CCS - Calculo accion de control para caudal optimo...");
         Pantalla_VP.Mostrar_CCS("CCS - Escritura de control (SC1) en Bomba1 mediante A/D...");
         Escritor_AD.Escribir_SC1;
         Pantalla_VP.Mostrar_CCS("CCS - Enviando telemetria a la Visualizacion por Pantalla (VP)...");
         Pantalla_VP.Mostrar_CCS("CCS - Registro de datos en el Almacenamiento de Datos (AD)...");
         Almacenamiento_Datos.Registrar("CCS - Registro de datos en AD");
      end loop;
   end Control_Campo_Solar;

   task body Control_Modulo_MD is
   begin
      loop
         Pantalla_VP.Mostrar_CMD("CMD - Solicitud lectura de tarjeta A/D...");
         Lector_AD.Leer_CMD;
         Pantalla_VP.Mostrar_CMD("CMD - Lectura de sensores de temperatura del modulo (ST2, ST3)...");
         Pantalla_VP.Mostrar_CMD("CMD - Calculo de Caudal requerido para producir 23 L/h...");
         Pantalla_VP.Mostrar_CMD("CMD - Escritura de control (SC2) en Bomba2 mediante A/D...");
         Escritor_AD.Escribir_SC2;
         Pantalla_VP.Mostrar_CMD("CMD - Enviando telemetria a la Visualizacion por Pantalla (VP)...");
         Pantalla_VP.Mostrar_CMD("CMD - Registro de datos en el Almacenamiento de Datos (AD)...");
         Almacenamiento_Datos.Registrar("CMD - Registro de datos en AD");
      end loop;
   end Control_Modulo_MD;

end Tareas;

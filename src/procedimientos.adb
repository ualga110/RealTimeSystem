with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

package body Procedimientos is


   -- Procedimiento auxiliar que simula el tiempo de timeout de AD
   procedure Timeout (Duracion : Time_Span) is
      Fin : Time := Clock + Duracion;
   begin
      delay until Fin;
   end Timeout;

   -- Sistema de Seguridad (SS)
   procedure Sistema_Seguridad is
   begin
      -- Lectura de sensores via tarjeta A/D (ST2 y entrada MD)
      Put_Line ("[SS] Solicitud de lectura Tarjeta A/D...");

      -- Comprobacion de los limites de seguridad (T < 95 C)
      Put_Line ("[SS] Comprobacion niveles de seguridad (T < 95 C)...");

      -- Envio del estado a la tarea de Visualizacion por Pantalla
      Put_Line ("[SS] Enviando estado a la Visualizacion por Pantalla (VP)...");

      -- Envio de señales de alarma al Almacenamiento de Datos
      -- con timeout de comunicacion de 10ms
      Put_Line ("[SS] Registro alarmas en el Almacenamiento de Datos (AD)...");
      Timeout (Milliseconds (10));

      Put_Line ("[SS] --------------------------------------------------");
   end Sistema_Seguridad;

   -- Sistema de Control del Campo Solar (CCS)
   procedure Control_Campo_Solar is
   begin
      -- Lectura de sensores (ST1, ST2, ST4, SR1) via tarjeta A/D
      Put_Line ("[CCS] Solicitud la lectura de la tarjeta A/D...");

      Put_Line ("[CCS] Lectura de sensores (ST1, ST2, ST4, SR1)...");

      -- Calculo de la accion de control para caudal optimo
      Put_Line ("[CCS] Calculo accion de control para caudal optimo...");

      -- Escritura de la señal de control SC1 en la tarjeta A/D
      Put_Line ("[CCS] Escritura señal de control (SC1) en Bomba 1 mediante A/D...");

      -- Envio de telemetria a la tarea de Visualizacion por Pantalla
      Put_Line ("[CCS] Enviando telemetria a la Visualizacion por Pantalla (VP)...");

      -- Registro de datos en el Almacenamiento con timeout de 10ms
      Put_Line ("[CCS] Registro de los datos en el Almacenamiento de Datos (AD)...");
      Timeout(Milliseconds (10));

      Put_Line ("[CCS] --------------------------------------------------");
   end Control_Campo_Solar;

   -- Sistema de Control del Modulo MD (CMD)
   procedure Control_Modulo_MD is
   begin
      -- Lectura de sensores (ST2, ST3) via tarjeta A/D
      Put_Line ("[CMD] Solicitud de lectura Tarjeta A/D...");

      Put_Line ("[CMD] Lectura de sensores de temperatura del modulo (ST2, ST3)...");

      -- Calculo del caudal requerido para producir 23 L/h
      Put_Line ("[CMD] Calculo de Caudal requerido para producir 23 L/h...");

      -- Escritura de la señal de control SC2 en la tarjeta A/D
      Put_Line ("[CMD] Escribiendo señal de control (SC2) en Bomba 2 mediante A/D...");

      -- Envio de telemetria a la tarea de Visualizacion por Pantalla
      Put_Line ("[CMD] Enviando telemetria a la Visualizacion por Pantalla (VP)...");

      -- Registro en el Almacenamiento con timeout de 15ms
      Put_Line ("[CMD] Registro de los datos en el Almacenamiento de Datos (AD)...");
      Timeout (Milliseconds (15));

      Put_Line ("[CMD] --------------------------------------------------");
   end Control_Modulo_MD;

end Procedimientos;

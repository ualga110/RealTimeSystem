with Ada.Text_IO; Use Ada.Text_IO;

package body Procedimientos is

   -- Tarea de Control de Campo Solar (CCS)

   procedure Control_Campo_Solar is
   begin
      Put_Line("CCS - Solicitud la lectura de la tarjeta A/D....");
      Put_Line("CCS - Lectura de sensores (ST1, ST2, ST4, SR1)...");
      Put_Line("CCS - Calculo accion de control para caudal optimo"...);
      Put_Line("CCS - Escritura señal de control (SC1) en Bomba 1 mediante A/D");
      Put_Line("CCS - Enviando telemetria a la Visualizacion por Pantalla (VP)...");
      Put_Line("CCS - Registro de los datos en el Almacenamiento de Datos (BD)...");
      Put_Line("------------------------------------------------------------------------");

   end Control_Campo_Solar;

   -- Tarea de Seguridad (SS)

   procedure Sistema_Seguridad is
   begin
      Put_Line("SS - Solicitud de lectura Tarjeta A/D....");
      Put_Line("SS - Lectura entrada del modulo y la salida de la temperatura del campo (ST2)...");
      Put_Line("SS - Comprobación niveles de seguridad (T < 95 C)...");
      Put_line("SS - Enviando estado a la Visualizacion por Pantalla (VP)...");
      Put_line("SS - Registro alarmas en el Almacenamiento de Datos (BD)....");
      Put_Line("--------------------------------------------------------------------------------------");

   end Sistema_Seguridad;

   -- Tarea de Control del Modulo MD (CMD)

   procedure Control_Modulo_MD is
   begin
      Put_Line("CMD - Solicitud de lectura Tarjeta A/D....");
      Put_Line("CMD - Lectura de sensores de temperatura del modulo (ST2, ST3)...");
      Put_Line("CMD - Calculo de Caudal requerido para producir 23 L/h...");
      Put_Line("CMD - Escribiendo señal de control (SC2) en bomba 2 mediante A/D....");
      Put_Line("CMD - Enviando telemetria a la Visualizacion por Pantalla (VP)...");
      Put_Line("Registro de los datos en el Almacenamiento de Datos (BD)...");
      Put_Line("--------------------------------------------------------------------------");


   end Control_Modulo_MD;

end Procedimientos;

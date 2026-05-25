-- procedimientos.adb
-- Cuerpo del paquete Procedimientos.
-- Cada procedimiento implementa las subtareas definidas en la Practica 2.
-- El tiempo de computo de cada subtarea es 8ms (delay until simulado).
-- Los timeouts de comunicacion con el almacenamiento (10ms para SS y CCS,
-- 15ms para CMD) estan incluidos en el tiempo total de cada procedimiento.
--
-- En el ejecutivo ciclico no es necesario usar mecanismos de exclusion
-- mutua porque en cada momento solo se ejecuta un procedimiento.

with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

package body Procedimientos is

   -- Tiempo de computo de cada subtarea individual
   Tc_Subtarea : constant Time_Span := Milliseconds (8);

   -- Procedimiento auxiliar que simula el tiempo de ejecucion de
   -- una subtarea con un delay activo de duracion Tc.
   -- Este patron se repite en cada subtarea de cada procedimiento.
   procedure Ejecutar_Subtarea (Duracion : Time_Span) is
      Fin : Time := Clock + Duracion;
   begin
      delay until Fin;
   end Ejecutar_Subtarea;

   -- ---------------------------------------------------------------
   -- Sistema de Seguridad (SS)
   -- C_SS = 4 subtareas x 8ms + timeout AD (10ms) = 42ms
   -- ---------------------------------------------------------------
   procedure Sistema_Seguridad is
   begin
      -- Subtarea 1: Lectura de sensores via tarjeta A/D (ST2 y entrada MD)
      Put_Line ("[SS] Solicitud de lectura Tarjeta A/D...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 2: Comprobacion de los limites de seguridad (T < 95 C)
      Put_Line ("[SS] Comprobacion niveles de seguridad (T < 95 C)...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 3: Envio del estado a la tarea de Visualizacion por Pantalla
      Put_Line ("[SS] Enviando estado a la Visualizacion por Pantalla (VP)...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 4: Envio de señales de alarma al Almacenamiento de Datos
      -- con timeout de comunicacion de 10ms
      Put_Line ("[SS] Registro alarmas en el Almacenamiento de Datos (AD)...");
      Ejecutar_Subtarea (Tc_Subtarea + Milliseconds (10));

      Put_Line ("[SS] --------------------------------------------------");
   end Sistema_Seguridad;

   -- ---------------------------------------------------------------
   -- Sistema de Control del Campo Solar (CCS)
   -- C_CCS = 5 subtareas x 8ms + timeout AD (10ms) = 50ms
   -- ---------------------------------------------------------------
   procedure Control_Campo_Solar is
   begin
      -- Subtarea 1: Lectura de sensores (ST1, ST2, ST4, SR1) via tarjeta A/D
      Put_Line ("[CCS] Solicitud la lectura de la tarjeta A/D...");
      Ejecutar_Subtarea (Tc_Subtarea);

      Put_Line ("[CCS] Lectura de sensores (ST1, ST2, ST4, SR1)...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 2: Calculo de la accion de control para caudal optimo
      Put_Line ("[CCS] Calculo accion de control para caudal optimo...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 3: Escritura de la señal de control SC1 en la tarjeta A/D
      Put_Line ("[CCS] Escritura señal de control (SC1) en Bomba 1 mediante A/D...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 4: Envio de telemetria a la tarea de Visualizacion por Pantalla
      Put_Line ("[CCS] Enviando telemetria a la Visualizacion por Pantalla (VP)...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 5: Registro de datos en el Almacenamiento con timeout de 10ms
      Put_Line ("[CCS] Registro de los datos en el Almacenamiento de Datos (AD)...");
      Ejecutar_Subtarea (Milliseconds (10));

      Put_Line ("[CCS] --------------------------------------------------");
   end Control_Campo_Solar;

   -- ---------------------------------------------------------------
   -- Sistema de Control del Modulo MD (CMD)
   -- C_CMD = 5 subtareas x 8ms + timeout AD (15ms) = 55ms
   -- ---------------------------------------------------------------
   procedure Control_Modulo_MD is
   begin
      -- Subtarea 1: Lectura de sensores (ST2, ST3) via tarjeta A/D
      Put_Line ("[CMD] Solicitud de lectura Tarjeta A/D...");
      Ejecutar_Subtarea (Tc_Subtarea);

      Put_Line ("[CMD] Lectura de sensores de temperatura del modulo (ST2, ST3)...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 2: Calculo del caudal requerido para producir 23 L/h
      Put_Line ("[CMD] Calculo de Caudal requerido para producir 23 L/h...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 3: Escritura de la señal de control SC2 en la tarjeta A/D
      Put_Line ("[CMD] Escribiendo señal de control (SC2) en Bomba 2 mediante A/D...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 4: Envio de telemetria a la tarea de Visualizacion por Pantalla
      Put_Line ("[CMD] Enviando telemetria a la Visualizacion por Pantalla (VP)...");
      Ejecutar_Subtarea (Tc_Subtarea);

      -- Subtarea 5: Registro en el Almacenamiento con timeout de 15ms
      Put_Line ("[CMD] Registro de los datos en el Almacenamiento de Datos (AD)...");
      Ejecutar_Subtarea (Milliseconds (15));

      Put_Line ("[CMD] --------------------------------------------------");
   end Control_Modulo_MD;

end Procedimientos;

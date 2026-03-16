-- ===========================================================================
--  Paquete  : Datos
--  Archivo  : datos.ads
--  Practica : Control de Instalacion de Destilacion por Membranas
--
--  Centraliza todos los tipos de datos del dominio, las constantes fisicas
--  del sistema y las rutas de ficheros. El resto de paquetes dependen de
--  este para mantener consistencia y facilitar el mantenimiento.
-- ===========================================================================

package Datos is

   -- -------------------------------------------------------------------------
   --  Tipos base del dominio
   -- -------------------------------------------------------------------------
   type Valor_Sensor  is new Float;
   type N_Iteracion   is new Natural;

   -- -------------------------------------------------------------------------
   --  Subtipos con rangos fisicos de cada tipo de sensor
   --  NOTA: los valores de ST1/ST2 calculados pueden superar 150 degC
   --  si SC1/SC2 son pequenos (p.ej. 1 L/min). Ajustar SC1/SC2 en main.adb
   --  o ampliar el rango si la simulacion lo requiere.
   -- -------------------------------------------------------------------------
   subtype Valor_Temperatura is Valor_Sensor range 0.0 .. 150.0;  -- Sensores ST (degC)
   subtype Valor_Caudal      is Valor_Sensor range 0.0 .. 1000.0; -- Sensores SC (L/min)
   subtype Valor_Radiacion   is Valor_Sensor range 0.0 .. 2000.0; -- Sensores SR (W/m2)

   -- -------------------------------------------------------------------------
   --  Registro unificado de un instante de muestreo k
   -- -------------------------------------------------------------------------
   type Iteracion_Registro is record
      -- Numero de iteracion
      N   : N_Iteracion;

      -- Temperaturas
      ST1 : Valor_Sensor;  -- Temp. salida colector  [degC]
      ST2 : Valor_Sensor;  -- Temp. entrada colector [degC]
      ST3 : Valor_Temperatura; -- Temp. entrada modulo   [degC]
      ST4 : Valor_Temperatura; -- Temp. enfriamiento     [degC]

      -- Caudales de control
      SC1 : Valor_Caudal;  -- Caudal circuito primario   [L/min]
      SC2 : Valor_Caudal;  -- Caudal circuito secundario [L/min]

      -- Radiacion solar
      SR1 : Valor_Radiacion; -- Irradiancia solar [W/m2]

      -- Destilado
      SD1 : Valor_Sensor;  -- Caudal destilado [L/dia]
   end record;

   -- -------------------------------------------------------------------------
   --  Constantes fisicas del sistema
   -- -------------------------------------------------------------------------
   Beta  : constant Float := 0.13;        -- m
   L_eq  : constant Float := 15.0;        -- m
   H     : constant Float := 4.0;         -- J/(s*K)
   C     : constant Float := 1_080_000.0; -- s*L/(min*m3)
   C_p   : constant Float := 4190.0;      -- J/(kg*degC)
   Rho   : constant Float := 976.0;       -- kg/m3

   -- -------------------------------------------------------------------------
   --  Rutas de ficheros
   -- -------------------------------------------------------------------------
   Carpeta_Archivos : constant String := "src/archivos/";
   Archivo_Entrada  : constant String := Carpeta_Archivos & "input.txt";
   Archivo_Log      : constant String := Carpeta_Archivos & "data_log.txt";
   Archivo_Alarm    : constant String := Carpeta_Archivos & "alarm_log.txt";

end Datos;

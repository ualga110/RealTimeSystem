

--  Tipos de datos del dominio, las constantes
--  del sistema y las rutas de ficheros. El resto de paquetes dependen de
--  este para mantener consistencia y facilitar el mantenimiento.


package Datos is


   --  Tipos base del dominio

   type Valor_Sensor    is new Float;
   type N_Iteracion     is new Natural;


   --  Subtipos con rangos fisicos de cada tipo de sensor

   subtype Valor_Temperatura is Valor_Sensor range 0.0 .. 200.0;  -- Sensores ST (degC)
   subtype Valor_Caudal      is Valor_Sensor range 0.0 .. 1000.0; -- Sensores SC (L/min o L/h)
   subtype Valor_Radiacion   is Valor_Sensor range 0.0 .. 2000.0; -- Sensores SR (W/m2)

   --  Registro unificado de un instante de muestreo k

   type Iteracion_Registro is record
      -- Numero de iteracion
      N   : N_Iteracion;

      -- Temperaturas de estado (calculadas por el simulador)
      ST1 : Valor_Sensor;     -- Temp. salida colector  [degC]
      ST2 : Valor_Sensor;     -- Temp. entrada colector [degC]

      -- Temperaturas de entrada (medidas)
      ST3 : Valor_Temperatura; -- Temp. entrada modulo   [degC]
      ST4 : Valor_Temperatura; -- Temp. enfriamiento     [degC]

      -- Caudales de control
      SC1 : Valor_Caudal;  -- Caudal circuito primario   [L/min]
      SC2 : Valor_Caudal;  -- Caudal circuito secundario [L/h]

      -- Radiacion solar
      SR1 : Valor_Radiacion; -- Irradiancia solar [W/m2]

      -- Destilado
      SD1 : Valor_Sensor;  -- Caudal destilado [L/dia]
   end record;

   --  Constantes fisicas del sistema

   Beta  : constant Float := 0.13;          -- m
   L_eq  : constant Float := 15.0;          -- m
   H     : constant Float := 4.0;           -- J/(s*K)
   C     : constant Float := 1_080_000.0;   -- s*L/(min*m3)
   C_p   : constant Float := 4190.0;        -- J/(kg*degC)
   Rho   : constant Float := 976.0;         -- kg/m3

   --  Condiciones iniciales de la simulacion (Ej.1: ST2(0)=55, ST1(0)=45)

   ST1_Inicial : constant Valor_Sensor := 45.0;  -- degC
   ST2_Inicial : constant Valor_Sensor := 55.0;  -- degC

   --  Caudales nominales fijos (Ej.1: SC1=15 L/min, SC2=400 L/h)

   SC1_Nominal : constant Valor_Caudal := 15.0;   -- L/min
   SC2_Nominal : constant Valor_Caudal := 400.0;  -- L/h


   --  Limites de seguridad
   ST2_Limite : constant Float := 95.0;  -- Temperatura maxima de ST2 [degC]

   --  Puntos de operacion optimos (para Ejercicio 2)

   ST2_Optimo : constant Float := 78.0;   -- degC (temperatura optima campo solar)
   SD1_Optimo : constant Float := 23.0;   -- L/h  (produccion optima destilado)

   -- Limites de los caudales de control (para Ejercicio 2)
   SC1_Min : constant Float :=   7.5;
   SC1_Max : constant Float :=  25.0;
   SC2_Min : constant Float := 150.0;
   SC2_Max : constant Float := 620.0;


   --  Rutas de ficheros

   Carpeta_Archivos : constant String := "src/archivos/";
   Archivo_Entrada  : constant String := Carpeta_Archivos & "input.txt";
   Archivo_Log      : constant String := Carpeta_Archivos & "data_log.txt";
   Archivo_Alarm    : constant String := Carpeta_Archivos & "alarm_log.txt";

end Datos;

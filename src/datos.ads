package Datos is

   type Valor_Sensor is new Float;
   type N_Iteracion is new Natural;
   
   subtype Valor_Temperatura is Valor_Sensor range 0.0 .. 150.0;
   subtype Valor_Caudal      is Valor_Sensor range 0.0 .. 1000.0;
   subtype Valor_Radiacion   is Valor_Sensor range 0.0 .. 2000.0; 
    
   type Iteracion_Registro is record
       N : N_Iteracion;
       ST1 : Valor_Temperatura;
       ST2 : Valor_Temperatura;
       ST3 : Valor_Temperatura;
       ST4 : Valor_Temperatura;
       SC1 : Valor_Caudal;
       SC2 : Valor_Caudal;
       SR1 : Valor_Radiacion;
       SD1 : Valor_Caudal;
   end record;
    
   Beta  : constant Float := 0.13;
   L_eq  : constant Float := 15.0;
   H     : constant Float := 4.0;
   C     : constant Float := 1080000.0;
   C_p   : constant Float := 4190.0;
   Rho   : constant Float := 976.0;
    
   Carpeta_Archivos : constant String := "src/archivos/";
   Archivo_Entrada : constant String := Carpeta_Archivos & "input.txt";
   Archivo_Log : constant String := Carpeta_Archivos & "data_log.txt";
   Archivo_Alarm : constant String := Carpeta_Archivos & "alarm_log.txt";
    
end Datos;

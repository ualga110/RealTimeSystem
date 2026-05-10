-- ===========================================================================
--  Paquete  : gestion_archivos
--  Archivo  : gestion_archivos.adb  (cuerpo)
--  Practica : Control de Instalacion de Destilacion por Membranas
--
--  El fichero de entrada se mantiene abierto durante toda la simulacion
--  (se abre en Inicializar y se cierra en Finalizar) para poder leer
--  linea a linea en cada iteracion del bucle de simulacion.
-- ===========================================================================

with Ada.Directories;
with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Float_Text_IO;
use Ada.Directories;
use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Ada.Float_Text_IO;

package body gestion_archivos is

   -- -------------------------------------------------------------------------
   --  Estado interno del paquete: fichero de entrada abierto
   -- -------------------------------------------------------------------------
   Fichero_Entrada : Ada.Text_IO.File_Type;
   Entrada_Abierta : Boolean := False;

   -- =========================================================================
   --  Inicializar
   -- =========================================================================
   procedure Inicializar is
   begin
      -- Verificar que existe el archivo de entrada
      if not Exists (Archivo_Entrada) then
         raise Program_Error with
           "No se encuentra el archivo de entrada: " & Archivo_Entrada;
      end if;

      -- Abrir el archivo de entrada para lectura secuencial
      Ada.Text_IO.Open (Fichero_Entrada, Ada.Text_IO.In_File, Archivo_Entrada);
      Entrada_Abierta := True;

      -- Crear cabeceras de los logs
      Crear_Cabecera_Log;
      Crear_Cabecera_Alarm;
   end Inicializar;

   -- =========================================================================
   --  Finalizar
   -- =========================================================================
   procedure Finalizar is
   begin
      if Entrada_Abierta then
         Ada.Text_IO.Close (Fichero_Entrada);
         Entrada_Abierta := False;
      end if;
   end Finalizar;

   -- =========================================================================
   --  Comprobar_Archivos  (compatibilidad)
   -- =========================================================================
   procedure Comprobar_Archivos is
   begin
      if not Exists (Archivo_Entrada) then
         raise Program_Error with
           "No se encuentra el archivo de entrada: " & Archivo_Entrada;
      end if;
   end Comprobar_Archivos;

   -- =========================================================================
   --  Crear_Cabecera_Log
   -- =========================================================================
   procedure Crear_Cabecera_Log is
      Fichero : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Create (Fichero, Ada.Text_IO.Out_File, Archivo_Log);
      Ada.Text_IO.Put_Line (Fichero,
        "   k |     ST1 |     ST2 |     ST3 |     ST4 |     SC1 |     SC2 |     SR1 |     SD1");
      Ada.Text_IO.Put_Line (Fichero,
        "-----|---------|---------|---------|---------|---------|---------|---------|---------");
      Ada.Text_IO.Close (Fichero);
   end Crear_Cabecera_Log;

   -- =========================================================================
   --  Crear_Cabecera_Alarm
   -- =========================================================================
   procedure Crear_Cabecera_Alarm is
      Fichero : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Create (Fichero, Ada.Text_IO.Out_File, Archivo_Alarm);
      Ada.Text_IO.Put_Line (Fichero, "   k | MENSAJE DE ALARMA");
      Ada.Text_IO.Put_Line (Fichero, "-----|---------------------------------------------");
      Ada.Text_IO.Close (Fichero);
   end Crear_Cabecera_Alarm;

   -- =========================================================================
   --  Leer_Siguiente
   --  Lee la siguiente linea del fichero de entrada (ya abierto en Inicializar)
   -- =========================================================================
   procedure Leer_Siguiente (Iteracion   : out N_Iteracion;
                              SR1         : out Valor_Radiacion;
                              ST4         : out Valor_Temperatura;
                              ST3         : out Valor_Temperatura;
                              Fin_Archivo : out Boolean) is
      I       : Integer;
      S1, T4, T3 : Float;
   begin
      if not Entrada_Abierta then
         raise Program_Error with "El archivo de entrada no esta abierto. Llame a Inicializar primero.";
      end if;

      -- Saltar lineas en blanco al final del archivo
      while not Ada.Text_IO.End_Of_File (Fichero_Entrada) loop
         if Ada.Text_IO.End_Of_Line (Fichero_Entrada) then
            Ada.Text_IO.Skip_Line (Fichero_Entrada);
         else
            exit;
         end if;
      end loop;

      if Ada.Text_IO.End_Of_File (Fichero_Entrada) then
         Fin_Archivo := True;
         Iteracion   := 0;
         SR1         := 0.0;
         ST4         := 0.0;
         ST3         := 0.0;
         return;
      end if;

      Ada.Integer_Text_IO.Get (Fichero_Entrada, I);
      Iteracion := N_Iteracion (I);

      Ada.Float_Text_IO.Get (Fichero_Entrada, S1);
      SR1 := Valor_Radiacion (S1);

      Ada.Float_Text_IO.Get (Fichero_Entrada, T4);
      ST4 := Valor_Temperatura (T4);

      Ada.Float_Text_IO.Get (Fichero_Entrada, T3);
      ST3 := Valor_Temperatura (T3);

      Fin_Archivo := False;
   end Leer_Siguiente;

   -- =========================================================================
   --  Leer_Entrada  (compatibilidad con firma anterior)
   -- =========================================================================
   procedure Leer_Entrada (Iteracion   : out N_Iteracion;
                            SR1         : out Valor_Radiacion;
                            ST4         : out Valor_Temperatura;
                            ST3         : out Valor_Temperatura;
                            Fin_Archivo : out Boolean) is
   begin
      Leer_Siguiente (Iteracion, SR1, ST4, ST3, Fin_Archivo);
   end Leer_Entrada;

   -- =========================================================================
   --  Registrar_Datos
   --  Añade una fila al data_log.txt
   --  Formato: k | ST1 | ST2 | ST3 | ST4 | SC1 | SC2 | SR1 | SD1
   -- =========================================================================
   procedure Registrar_Datos (Fila : in Iteracion_Registro) is
      Fichero : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Open (Fichero, Ada.Text_IO.Append_File, Archivo_Log);

      Ada.Integer_Text_IO.Put (Fichero, Integer (Fila.N), Width => 4);
      Ada.Text_IO.Put (Fichero, " | ");
      Ada.Float_Text_IO.Put (Fichero, Float (Fila.ST1), Fore => 4, Aft => 2, Exp => 0);
      Ada.Text_IO.Put (Fichero, " | ");
      Ada.Float_Text_IO.Put (Fichero, Float (Fila.ST2), Fore => 4, Aft => 2, Exp => 0);
      Ada.Text_IO.Put (Fichero, " | ");
      Ada.Float_Text_IO.Put (Fichero, Float (Fila.ST3), Fore => 4, Aft => 2, Exp => 0);
      Ada.Text_IO.Put (Fichero, " | ");
      Ada.Float_Text_IO.Put (Fichero, Float (Fila.ST4), Fore => 4, Aft => 2, Exp => 0);
      Ada.Text_IO.Put (Fichero, " | ");
      Ada.Float_Text_IO.Put (Fichero, Float (Fila.SC1), Fore => 4, Aft => 2, Exp => 0);
      Ada.Text_IO.Put (Fichero, " | ");
      Ada.Float_Text_IO.Put (Fichero, Float (Fila.SC2), Fore => 6, Aft => 2, Exp => 0);
      Ada.Text_IO.Put (Fichero, " | ");
      Ada.Float_Text_IO.Put (Fichero, Float (Fila.SR1), Fore => 4, Aft => 2, Exp => 0);
      Ada.Text_IO.Put (Fichero, " | ");
      Ada.Float_Text_IO.Put (Fichero, Float (Fila.SD1), Fore => 4, Aft => 2, Exp => 0);
      Ada.Text_IO.New_Line (Fichero);

      Ada.Text_IO.Close (Fichero);
   end Registrar_Datos;

   -- =========================================================================
   --  Registrar_Alarma
   --  Añade una linea al alarm_log.txt
   -- =========================================================================
   procedure Registrar_Alarma (K : in N_Iteracion; Mensaje : in String) is
      Fichero : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Open (Fichero, Ada.Text_IO.Append_File, Archivo_Alarm);
      Ada.Integer_Text_IO.Put (Fichero, Integer (K), Width => 4);
      Ada.Text_IO.Put (Fichero, " | ");
      Ada.Text_IO.Put (Fichero, Mensaje);
      Ada.Text_IO.New_Line (Fichero);
      Ada.Text_IO.Close (Fichero);
   end Registrar_Alarma;

end gestion_archivos;

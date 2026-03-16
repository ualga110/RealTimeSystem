-- ===========================================================================
--  Programa principal : main.adb
--  Practica           : Control de Instalacion de Destilacion por Membranas
--  Ejercicio          : 1 — Simulacion de la planta
--
--  Lee los datos de Datos.Archivo_Entrada (src/archivos/input.txt).
--  Formato de cada linea del fichero:  k  SR1  ST4  ST3
--
--  SC1 y SC2 se establecen como constantes nominales al inicio del programa.
-- ===========================================================================

with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Float_Text_IO;    use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Datos;                use Datos;
with Simulador;            use Simulador;

procedure Main is

   -- -------------------------------------------------------------------------
   --  Caudales de control nominales (ajustar si el enunciado los especifica)
   -- -------------------------------------------------------------------------
   SC1_Nominal : constant Valor_Caudal := 1.0;
   SC2_Nominal : constant Valor_Caudal := 1.0;

   -- -------------------------------------------------------------------------
   --  Registros de estado
   --  Paso_Previo  : estado k-1  (condiciones iniciales: ST1=0, ST2=0)
   --  Paso_Actual  : datos de entrada leidos del fichero en cada iteracion
   --  Resultado    : estado k calculado por el simulador
   -- -------------------------------------------------------------------------
   Paso_Previo : Iteracion_Registro :=
     (N   => 0,
      ST1 => 0.0,
      ST2 => 0.0,
      ST3 => 0.0,
      ST4 => 0.0,
      SC1 => SC1_Nominal,
      SC2 => SC2_Nominal,
      SR1 => 0.0,
      SD1 => 0.0);

   Paso_Actual : Iteracion_Registro;
   Resultado   : Iteracion_Registro;

   -- -------------------------------------------------------------------------
   --  Handles de ficheros
   -- -------------------------------------------------------------------------
   F_Entrada : Ada.Text_IO.File_Type;
   F_Log     : Ada.Text_IO.File_Type;

   -- Variable auxiliar para leer el indice k del fichero
   K_Leido : Integer;

   -- -------------------------------------------------------------------------
   --  Procedimiento: Separador de tabla
   -- -------------------------------------------------------------------------
   procedure Separador is
   begin
      Put_Line
        ("+----+------------+----------+----------" &
         "+-------------+-------------+-------------+");
   end Separador;

   -- -------------------------------------------------------------------------
   --  Procedimiento: Imprimir una fila de resultados en pantalla y en log
   -- -------------------------------------------------------------------------
   procedure Imprimir_Fila (R : Iteracion_Registro) is

      procedure Fila (F : Ada.Text_IO.File_Type) is
      begin
         Put (F, "| ");
         Put (F, Integer (R.N), Width => 2);
         Put (F, " | ");
         Put (F, Float (R.SR1), Fore => 4, Aft => 1, Exp => 0);
         Put (F, "     | ");
         Put (F, Float (R.ST4), Fore => 4, Aft => 1, Exp => 0);
         Put (F, "   | ");
         Put (F, Float (R.ST3), Fore => 4, Aft => 1, Exp => 0);
         Put (F, "   | ");
         Put (F, Float (R.ST2), Fore => 5, Aft => 4, Exp => 0);
         Put (F, "  | ");
         Put (F, Float (R.ST1), Fore => 5, Aft => 4, Exp => 0);
         Put (F, "  | ");
         Put (F, Float (R.SD1), Fore => 5, Aft => 4, Exp => 0);
         Put (F, "  |");
         New_Line (F);
      end Fila;

   begin
      Fila (Ada.Text_IO.Standard_Output);
      Fila (F_Log);
   end Imprimir_Fila;

   -- -------------------------------------------------------------------------
   --  Procedimiento: Escribir cabecera en un fichero dado
   -- -------------------------------------------------------------------------
   procedure Imprimir_Cabecera (F : Ada.Text_IO.File_Type) is
   begin
      New_Line (F);
      Put_Line (F, "  Simulador - Instalacion de Destilacion por Membranas (Ejercicio 1)");
      New_Line (F);
      Put_Line (F, "  Constantes: Beta=" & Float'Image (Beta) &
                   "  L_eq=" & Float'Image (L_eq) &
                   "  H=" & Float'Image (H));
      Put_Line (F, "             C=" & Float'Image (C) &
                   "  C_p=" & Float'Image (C_p) &
                   "  Rho=" & Float'Image (Rho));
      Put_Line (F, "  Fichero de entrada : " & Archivo_Entrada);
      Put_Line (F, "  Log de datos       : " & Archivo_Log);
      Put_Line (F, "  C.Iniciales        : ST1(0)=0.0  ST2(0)=0.0");
      Put_Line (F, "  SC1=" & Float'Image (Float (SC1_Nominal)) & " L/min" &
                   "   SC2=" & Float'Image (Float (SC2_Nominal)) & " L/min");
      New_Line (F);
      Separador;
      Put_Line (F,
        "| k  | SR1[W/m2]  | ST4[C]   | ST3[C]   " &
        "| ST2[C]      | ST1[C]      | SD1[L/dia]  |");
      Separador;
   end Imprimir_Cabecera;

begin

   -- -------------------------------------------------------------------------
   --  Abrir fichero de entrada
   -- -------------------------------------------------------------------------
   begin
      Ada.Text_IO.Open (F_Entrada, Ada.Text_IO.In_File, Archivo_Entrada);
   exception
      when Ada.Text_IO.Name_Error =>
         Put_Line ("ERROR: No se encuentra: " & Archivo_Entrada);
         return;
   end;

   -- -------------------------------------------------------------------------
   --  Abrir (o crear) fichero de log
   -- -------------------------------------------------------------------------
   begin
      Ada.Text_IO.Create (F_Log, Ada.Text_IO.Out_File, Archivo_Log);
   exception
      when others =>
         Put_Line ("AVISO: No se pudo crear el log: " & Archivo_Log);
   end;

   -- -------------------------------------------------------------------------
   --  Cabecera en pantalla y en log
   -- -------------------------------------------------------------------------
   Imprimir_Cabecera (Ada.Text_IO.Standard_Output);
   Imprimir_Cabecera (F_Log);

   -- -------------------------------------------------------------------------
   --  Bucle de lectura y simulacion
   --  Formato de cada linea de input.txt:  k  SR1  ST4  ST3
   -- -------------------------------------------------------------------------
   while not Ada.Text_IO.End_Of_File (F_Entrada) loop

      -- Variables auxiliares para leer del fichero (Get requiere Float)
      declare
         F_SR1 : Float;
         F_ST4 : Float;
         F_ST3 : Float;
      begin
         -- Leer los cuatro tokens de la linea
         Ada.Integer_Text_IO.Get (F_Entrada, K_Leido);
         Ada.Float_Text_IO.Get   (F_Entrada, F_SR1);
         Ada.Float_Text_IO.Get   (F_Entrada, F_ST4);
         Ada.Float_Text_IO.Get   (F_Entrada, F_ST3);

         -- Asignar al registro de entrada con conversion de tipo
         Paso_Actual.N   := N_Iteracion (K_Leido);
         Paso_Actual.SR1 := Valor_Radiacion   (F_SR1);
         Paso_Actual.ST4 := Valor_Temperatura (F_ST4);
         Paso_Actual.ST3 := Valor_Temperatura (F_ST3);
         Paso_Actual.SC1 := SC1_Nominal;
         Paso_Actual.SC2 := SC2_Nominal;
         Paso_Actual.ST1 := Paso_Previo.ST1;
         Paso_Actual.ST2 := Paso_Previo.ST2;
         Paso_Actual.SD1 := 0.0;
      end;

      -- Llamada al simulador
      Resultado := Calcular_Paso (Paso_Actual, Paso_Previo);

      -- Imprimir fila en consola y en log
      Imprimir_Fila (Resultado);

      -- Avanzar estado: el resultado de k se convierte en el previo de k+1
      Paso_Previo := Resultado;

   end loop;

   -- -------------------------------------------------------------------------
   --  Pie de tabla y cierre de ficheros
   -- -------------------------------------------------------------------------
   Separador;
   Separador;  -- tambien en log (via Imprimir_Fila que llama a ambos)
   New_Line;
   Put_Line ("  Simulacion finalizada. Log guardado en: " & Archivo_Log);
   New_Line;

   Ada.Text_IO.Close (F_Entrada);
   Ada.Text_IO.Close (F_Log);

end Main;

with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Float_Text_IO;    use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Datos;                use Datos;
with Simulador;            use Simulador;
with gestion_archivos;     use gestion_archivos;

procedure Main is

   SC1_Nominal : constant Valor_Caudal := 1.0;
   SC2_Nominal : constant Valor_Caudal := 1.0;

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

   Iteracion : N_Iteracion;
   SR1 : Valor_Radiacion;
   ST4 : Valor_Temperatura;
   ST3 : Valor_Temperatura;
   Fin : Boolean := False;

begin
   Comprobar_Archivos;
   Crear_Cabecera_Log;
   Abrir_Entrada;

   Put_Line("=== Ejercicio 1: Simulacion de la planta ===");
   New_Line;

   while not Fin loop
      Leer_Entrada(Iteracion, SR1, ST4, ST3, Fin);

      if Fin then
         exit;
      end if;

      Paso_Actual.N   := Iteracion;
      Paso_Actual.SR1 := SR1;
      Paso_Actual.ST4 := ST4;
      Paso_Actual.ST3 := ST3;
      Paso_Actual.SC1 := SC1_Nominal;
      Paso_Actual.SC2 := SC2_Nominal;
      Paso_Actual.ST1 := Paso_Previo.ST1;
      Paso_Actual.ST2 := Paso_Previo.ST2;
      Paso_Actual.SD1 := 0.0;

      Resultado := Calcular_Paso(Paso_Actual, Paso_Previo);

      Put("Iteracion: ");
      Put(Integer(Resultado.N), Width => 3);
      Put(" | SR1: ");
      Put(Float(Resultado.SR1), Fore => 4, Aft => 1, Exp => 0);
      Put(" | ST4: ");
      Put(Float(Resultado.ST4), Fore => 4, Aft => 1, Exp => 0);
      Put(" | ST3: ");
      Put(Float(Resultado.ST3), Fore => 4, Aft => 1, Exp => 0);
      Put(" -> ST2: ");
      Put(Float(Resultado.ST2), Fore => 5, Aft => 2, Exp => 0);
      Put(" | ST1: ");
      Put(Float(Resultado.ST1), Fore => 5, Aft => 2, Exp => 0);
      Put(" | SD1: ");
      Put(Float(Resultado.SD1), Fore => 5, Aft => 2, Exp => 0);
      New_Line;

      Paso_Previo := Resultado;
   end loop;

   Cerrar_Entrada;

   New_Line;
   Put_Line("Simulacion finalizada.");
   New_Line;
   Put_Line("Log de datos: src/archivos/data_log.txt");
   Put_Line("Log de alarmas: src/archivos/alarm_log.txt");

end Main;

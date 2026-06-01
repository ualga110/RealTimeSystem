with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Real_Time;  use Ada.Real_Time;
with Procedimientos;

procedure Main_Ej1 is

   -- Periodo del ciclo secundario
   Ts : constant Time_Span := Milliseconds (100);

   -- Turno de tipo mod 4: al llegar a 4 vuelve a 0 automaticamente,
   -- haciendo que el hiperperiodo se repita indefinidamente.
   type Ciclo is mod 4;
   Turno : Ciclo := 0;

   T : Time;

begin

   T := Clock;

   loop
      -- Se avanza al instante de inicio del proximo subciclo.
      -- Usar instante absoluto evita que los errores de tiempo se acumulen.
      T := T + Ts;
      delay until T;

      Put_Line ("--- Subciclo" & Ciclo'Image (Turno) & " ---");

      case Turno is

         when 0 =>
            -- SS se activa en todos los subciclos (T=100ms)
            -- CCS se activa en subciclos 0 y 2 (T=200ms)
            -- SS(42ms) + CCS(50ms) = 92ms < Ts=100ms
            Procedimientos.Sistema_Seguridad;
            Procedimientos.Control_Campo_Solar;

         when 1 =>
            -- CMD se activa aqui porque en el subciclo 0 no habia hueco
            -- SS(42ms) + CMD(55ms) = 97ms < Ts=100ms y su plazo es 400ms, cumple con margen
            Procedimientos.Sistema_Seguridad;
            Procedimientos.Control_Modulo_MD;

         when 2 =>
            -- SS + CCS de nuevo (segunda activacion en el hiperperiodo)
            Procedimientos.Sistema_Seguridad;
            Procedimientos.Control_Campo_Solar;

         when 3 =>
            -- Solo SS (cuarta activacion; CCS y CMD no se activan aqui)
            Procedimientos.Sistema_Seguridad;

      end case;

      Turno := Turno + 1;

   end loop;

end Main_Ej1;

-- main_ej1.adb
-- Ejecutivo ciclico para el sistema de control de la instalacion
-- de destilacion por membranas (Practica 5, Ejercicio 1).
--
-- Tareas y periodos (P5):
--   SS  (Seguridad)    T=100ms  C=42ms  (4 subtareas x 8ms + 10ms timeout)
--   CCS (Campo Solar)  T=200ms  C=50ms  (5 subtareas x 8ms + 10ms timeout)
--   CMD (Modulo MD)    T=400ms  C=55ms  (5 subtareas x 8ms + 15ms timeout)
--
-- Hiperperiodo H = mcm(100,200,400) = 400ms
-- Ciclo secundario Ts = 100ms (menor periodo)
-- Numero de subciclos: H/Ts = 4
--
-- Cronograma (SS=42ms, CCS=50ms, CMD=55ms, Ts=100ms):
--   Subciclo 0: SS(42ms) + CCS(50ms) = 92ms < 100ms  OK
--   Subciclo 1: CMD(55ms)            = 55ms < 100ms  OK
--   Subciclo 2: SS(42ms) + CCS(50ms) = 92ms < 100ms  OK
--   Subciclo 3: SS(42ms)             = 42ms < 100ms  OK
--
-- CMD no puede ejecutarse en el subciclo 0 junto con SS y CCS porque
-- 42+50+55=147ms > 100ms. Al ejecutarse en el subciclo 1 (t=100ms)
-- cumple su plazo de 400ms con suficiente margen.

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
   Put_Line ("=== Ejecutivo Ciclico - Sistema de Destilacion por Membranas ===");
   Put_Line ("Ts=100ms | H=400ms | SS(42ms) CCS(50ms) CMD(55ms)");
   New_Line;

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
            -- CMD(55ms) < Ts=100ms y su plazo es 400ms, cumple con margen
            Procedimientos.Control_Modulo_MD;

         when 2 =>
            -- SS + CCS de nuevo (segunda activacion en el hiperperiodo)
            Procedimientos.Sistema_Seguridad;
            Procedimientos.Control_Campo_Solar;

         when 3 =>
            -- Solo SS (cuarta activacion; CCS y CMD no se activan aqui)
            Procedimientos.Sistema_Seguridad;

      end case;

      -- El operador + sobre tipo mod hace el modulo automaticamente:
      -- cuando Turno vale 3, Turno+1 = 0 (vuelve al inicio del hiperperiodo)
      Turno := Turno + 1;

   end loop;

end Main_Ej1;

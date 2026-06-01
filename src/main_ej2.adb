with Ada.Real_Time;  use Ada.Real_Time;
with Ada.Text_IO;    use Ada.Text_IO;
with System;
with Recursos;

procedure Main_Ej2 is

   -- Tarea: Sistema de Seguridad
   -- Periodo T = 100 ms | Prioridad = 3 (la mas alta)
   -- Subtareas: lectura A/D, pantalla
   task SS is
      pragma Priority (3);
   end SS;

   task body SS is
      Periodo : constant Time_Span := Milliseconds (150);
      Proximo : Time := Clock + Periodo;
   begin
      loop
         -- Espera hasta el instante de activacion planificado.
         delay until Proximo;

         delay 0.026;
         -- Acceso a recurso compartido: tarjeta A/D
         Recursos.Tarjeta_AD.Usar;

         -- Acceso a recurso compartido: pantalla
         Recursos.Pantalla.Mostrar ("[SS] Estado del sistema OK");

         -- Calcula el proximo instante de activacion sumando el periodo.
         Proximo := Proximo + Periodo;
      end loop;
   end SS;

   -- Tarea: Sistema de Control del Campo CCS
   -- Periodo T = 200 ms | Prioridad = 2
   -- Subtareas: lectura A/D, pantalla, almacenamiento
   task CCS is
      pragma Priority (2);
   end CCS;

   task body CCS is
      Periodo : constant Time_Span := Milliseconds (200);
      Proximo : Time := Clock + Periodo;
   begin
      loop
         delay until Proximo;

         delay 0.026;
         Recursos.Tarjeta_AD.Usar;
         Recursos.Pantalla.Mostrar ("[CCS] Temperatura campo CCS procesada");
         Recursos.Almacenamiento.Guardar ("[CCS]: datos de temperatura almacenados");

         Proximo := Proximo + Periodo;
      end loop;
   end CCS;

   -- Tarea: Sistema de Control del Modulo MD
   -- Periodo T = 400 ms | Prioridad = 1 (la mas baja)
   -- Subtareas: lectura A/D, pantalla, almacenamiento
   task CMD is
      pragma Priority (1);
   end CMD;

   task body CMD is
      Periodo : constant Time_Span := Milliseconds (400);
      Proximo : Time := Clock + Periodo;
   begin
      loop
         delay until Proximo;

         delay 0.031;
         Recursos.Tarjeta_AD.Usar;
         Recursos.Pantalla.Mostrar ("[CMD] Presion y flujo del modulo CMD procesados");
         Recursos.Almacenamiento.Guardar ("[CMD]: datos de presion y flujo almacenados");

         Proximo := Proximo + Periodo;
      end loop;
   end CMD;

begin
   -- El programa principal no hace nada: las tres tareas se crean
   -- automaticamente al arrancar y se ejecutan en paralelo.

   -- Se espera un tiempo suficiente para observar varios hiperperiodos
   delay 2.0;

end Main_Ej2;

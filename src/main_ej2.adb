-- main_ej2.adb
-- Planificacion con prioridades y tareas concurrentes para el sistema
-- de control de la instalacion de destilacion por membranas.
--
-- Asignacion de prioridades (Rate Monotonic Scheduling):
--   Seguridad (T=100ms) --> prioridad 3  (mayor frecuencia = mayor prioridad)
--   Solar     (T=200ms) --> prioridad 2
--   MD        (T=400ms) --> prioridad 1  (menor frecuencia = menor prioridad)
--
-- Tiempos de computo (Ci) por tarea (3 subtareas x 8ms cada una):
--   C_Seg = 24 ms,  C_Sol = 24 ms,  C_MD = 24 ms
--
-- Factor de utilizacion:
--   U = 24/100 + 24/200 + 24/400 = 0.24 + 0.12 + 0.06 = 0.42
--
-- Condicion de garantia RMS para N=3: U0(3) = 3*(2^(1/3)-1) = 0.779
--   U = 0.42 <= 0.779 --> Sistema garantizado
--
-- Tiempos de respuesta (calculo iterativo con herencia de prioridad):
--   R_Seg = 24 ms  (no hay tareas de mayor prioridad)
--   R_Sol = 24 + ceil(24/100)*24 = 48 ms < 200 ms  --> OK
--   R_MD  = 24 + ceil(R_MD/100)*24 + ceil(R_MD/200)*24
--         w0=72, w1=72 --> R_MD = 72 ms < 400 ms  --> OK

with Ada.Real_Time;  use Ada.Real_Time;
with Ada.Text_IO;    use Ada.Text_IO;
with System;
with Recursos;

procedure Main_Ej2 is

   -- ---------------------------------------------------------------
   -- Tarea: Sistema de Seguridad
   -- Periodo T = 100 ms | Prioridad = 3 (la mas alta)
   -- Subtareas: lectura A/D, pantalla
   -- ---------------------------------------------------------------
   task Seguridad is
      pragma Priority (3);
   end Seguridad;

   task body Seguridad is
      Periodo : constant Time_Span := Milliseconds (100);
      Proximo : Time := Clock + Periodo;
   begin
      loop
         -- Espera hasta el instante de activacion planificado.
         -- Este patron (delay until con instante absoluto) es el
         -- mecanismo estandar para implementar tareas periodicas en Ada.
         delay until Proximo;

         -- Acceso a recurso compartido: tarjeta A/D
         -- El objeto protegido garantiza exclusion mutua automaticamente.
         Recursos.Tarjeta_AD.Usar;

         -- Acceso a recurso compartido: pantalla
         Recursos.Pantalla.Mostrar ("[Seguridad] Estado del sistema OK");

         -- Calcula el proximo instante de activacion sumando el periodo.
         -- Usar instantes absolutos evita la deriva temporal acumulada
         -- que produciria un simple delay Periodo.
         Proximo := Proximo + Periodo;
      end loop;
   end Seguridad;

   -- ---------------------------------------------------------------
   -- Tarea: Sistema de Control del Campo Solar
   -- Periodo T = 200 ms | Prioridad = 2
   -- Subtareas: lectura A/D, pantalla, almacenamiento
   -- ---------------------------------------------------------------
   task Solar is
      pragma Priority (2);
   end Solar;

   task body Solar is
      Periodo : constant Time_Span := Milliseconds (200);
      Proximo : Time := Clock + Periodo;
   begin
      loop
         delay until Proximo;

         Recursos.Tarjeta_AD.Usar;
         Recursos.Pantalla.Mostrar ("[Solar] Temperatura campo solar procesada");
         Recursos.Almacenamiento.Guardar ("Solar: datos de temperatura almacenados");

         Proximo := Proximo + Periodo;
      end loop;
   end Solar;

   -- ---------------------------------------------------------------
   -- Tarea: Sistema de Control del Modulo MD
   -- Periodo T = 400 ms | Prioridad = 1 (la mas baja)
   -- Subtareas: lectura A/D, pantalla, almacenamiento
   -- ---------------------------------------------------------------
   task MD is
      pragma Priority (1);
   end MD;

   task body MD is
      Periodo : constant Time_Span := Milliseconds (400);
      Proximo : Time := Clock + Periodo;
   begin
      loop
         delay until Proximo;

         Recursos.Tarjeta_AD.Usar;
         Recursos.Pantalla.Mostrar ("[MD] Presion y flujo del modulo MD procesados");
         Recursos.Almacenamiento.Guardar ("MD: datos de presion y flujo almacenados");

         Proximo := Proximo + Periodo;
      end loop;
   end MD;

begin
   -- El programa principal no hace nada: las tres tareas se crean
   -- automaticamente al arrancar y se ejecutan en paralelo.
   -- El planificador de Ada con prioridades fijas y desalojo garantiza
   -- que en cada momento se ejecuta la tarea activa de mayor prioridad.
   Put_Line ("=== Sistema concurrente con prioridades RMS ===");
   Put_Line ("Seguridad P=3 T=100ms | Solar P=2 T=200ms | MD P=1 T=400ms");
   New_Line;

   -- Se espera un tiempo suficiente para observar varios hiperperiodos
   delay 2.0;

end Main_Ej2;

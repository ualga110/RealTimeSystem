with Tareas;
with Procedimientos; use Procedimientos;
procedure Main is

begin

   -- el programa principal no hace nada, las tareas corren de forma concurrente
   -- en segundo plano

   loop

      delay 10.0;

   end loop;
end Main;

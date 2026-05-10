package tareas is

   -- recursos compartidos
   -- Se usa un objeto protegido para evitar que las tareas no se mezclen entre si
   
   protected Pantalla is
      procedure Escribir (Mensaje : in String);
   end Pantalla;
   
   -- Tareas
   task Sistema_Seguridad;
   task Control_Campo_Solar;
   task Control_Modulo_MD;

end tareas;

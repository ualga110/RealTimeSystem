package Tareas is

    -- Tarea servidora para la Visualizacion por Pantalla (VP)
    -- Espera mensajes (citas) desde las tareas principales para mostrar informacion
    task Pantalla_VP is
       entry Mostrar_CCS(Msg : in String);
       entry Mostrar_CMD(Msg : in String);
       entry Mostrar_SS(Msg : in String);
    end Pantalla_VP;

    -- Tarea servidora para LECTURA de la tarjeta A/D (gestiona Recurso_Read_AD)
    -- Atiende peticiones de lectura de sensores de las tareas principales
    task Lector_AD is
       entry Leer_CCS;
       entry Leer_CMD;
       entry Leer_SS;
    end Lector_AD;

    -- Tarea servidora para ESCRITURA de la tarjeta A/D (gestiona Recurso_Write_AD)
    -- Atiende peticiones de escritura en actuadores de las tareas de control
    task Escritor_AD is
       entry Escribir_SC1;
       entry Escribir_SC2;
    end Escritor_AD;

    -- Objeto protegido para el Almacenamiento de Datos (AD)
    -- Solo permite el acceso de una tarea a la vez (exclusion mutua)
    protected Almacenamiento_Datos is
       procedure Registrar(Datos : in String);
    end Almacenamiento_Datos;

   -- Tareas principales del sistema
   task Sistema_Seguridad is
   end Sistema_Seguridad;

   task Control_Campo_Solar is
   end Control_Campo_Solar;

   task Control_Modulo_MD is
   end Control_Modulo_MD;

end Tareas;

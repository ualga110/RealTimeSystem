with Datos;
use Datos;

package gestion_archivos is

   -- Comprueba si existe el archivo input.txt, si no el programa no continua
   procedure Comprobar_Archivos;

   procedure Crear_Cabecera_Log;
   procedure Crear_Cabecera_Alarm;

   -- Abre el archivo de Input_File dentro del método
   procedure Abrir_Entrada;

   -- Cierra el archivo de Input_File dentro del método
   procedure Cerrar_Entrada;
   
   -- Lee la entrada de input.txt, si ha terminado el archivo Fin_Archivo = True
   procedure Leer_Entrada (Iteracion : out N_Iteracion;
                          SR1         : out Valor_Radiacion; 
                          ST4         : out Valor_Temperatura; 
                          ST3         : out Valor_Temperatura;
                          Fin_Archivo : out Boolean);
   
   -- Registra los datos en data_log.txt
   procedure Registrar_Datos (Fila : in Iteracion_Registro);
   
   -- Registra la alarma en alarm_log.txt
   procedure Registrar_Alarma (K : in N_Iteracion; Mensaje : in String);

end gestion_archivos;

-- ===========================================================================
--  Paquete  : gestion_archivos
--  Archivo  : gestion_archivos.ads  (especificacion)
--  Practica : Control de Instalacion de Destilacion por Membranas
--
--  Gestiona la lectura del fichero de entrada (input.txt) y la escritura
--  en los ficheros de log (data_log.txt) y alarmas (alarm_log.txt).
--
--  USO:
--    1. Llamar a Inicializar antes del bucle de simulacion.
--    2. Llamar a Leer_Siguiente dentro del bucle.
--    3. Llamar a Finalizar al terminar.
-- ===========================================================================

with Datos;
use Datos;

package gestion_archivos is

   -- -------------------------------------------------------------------------
   --  Inicializar:
   --    - Verifica que exista input.txt.
   --    - Abre el fichero de entrada para lectura secuencial.
   --    - Crea (o sobreescribe) los ficheros data_log.txt y alarm_log.txt
   --      con su cabecera correspondiente.
   -- -------------------------------------------------------------------------
   procedure Inicializar;

   -- -------------------------------------------------------------------------
   --  Leer_Siguiente:
   --    Lee la siguiente linea de input.txt.
   --    Formato de cada linea: k  SR1  ST4  ST3
   --    Parametros de salida:
   --      Iteracion   : numero de iteracion k
   --      SR1         : irradiancia solar [W/m2]
   --      ST4         : temperatura de enfriamiento [degC]
   --      ST3         : temperatura de entrada al modulo [degC]
   --      Fin_Archivo : True cuando ya no quedan mas lineas
   -- -------------------------------------------------------------------------
   procedure Leer_Siguiente (Iteracion   : out N_Iteracion;
                              SR1         : out Valor_Radiacion;
                              ST4         : out Valor_Temperatura;
                              ST3         : out Valor_Temperatura;
                              Fin_Archivo : out Boolean);

   -- -------------------------------------------------------------------------
   --  Registrar_Datos:
   --    Añade una fila al fichero data_log.txt con todos los valores del
   --    registro de la iteracion k.
   --    Formato: k | ST1 | ST2 | ST3 | ST4 | SC1 | SC2 | SR1 | SD1
   -- -------------------------------------------------------------------------
   procedure Registrar_Datos (Fila : in Iteracion_Registro);

   -- -------------------------------------------------------------------------
   --  Registrar_Alarma:
   --    Añade una linea al fichero alarm_log.txt con el numero de iteracion
   --    y el mensaje de alarma.
   -- -------------------------------------------------------------------------
   procedure Registrar_Alarma (K : in N_Iteracion; Mensaje : in String);

   -- -------------------------------------------------------------------------
   --  Finalizar:
   --    Cierra el fichero de entrada si sigue abierto.
   -- -------------------------------------------------------------------------
   procedure Finalizar;

   -- -------------------------------------------------------------------------
   --  (Para compatibilidad con versiones anteriores)
   -- -------------------------------------------------------------------------
   procedure Comprobar_Archivos;
   procedure Crear_Cabecera_Log;
   procedure Crear_Cabecera_Alarm;

   -- Firma antigua — delega en Leer_Siguiente internamente
   procedure Leer_Entrada (Iteracion   : out N_Iteracion;
                            SR1         : out Valor_Radiacion;
                            ST4         : out Valor_Temperatura;
                            ST3         : out Valor_Temperatura;
                            Fin_Archivo : out Boolean);

end gestion_archivos;

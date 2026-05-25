-- procedimientos.ads
-- Especificacion del paquete Procedimientos para el ejecutivo ciclico.
-- Las tres subrutinas corresponden exactamente a las tareas definidas
-- en la Practica 2 del sistema de destilacion por membranas.

package Procedimientos is

   -- Sistema de Seguridad (SS) -- periodo T=100ms
   -- Subtareas: leer A/D, comprobar limites, envio VP, envio alarma AD
   procedure Sistema_Seguridad;

   -- Sistema de Control del Campo Solar (CCS) -- periodo T=200ms
   -- Subtareas: leer A/D, calcular control SC1, escribir SC1 en A/D,
   --            envio VP, envio datos AD
   procedure Control_Campo_Solar;

   -- Sistema de Control del Modulo MD (CMD) -- periodo T=400ms
   -- Subtareas: leer A/D, calcular control SC2, escribir SC2 en A/D,
   --            envio VP, envio datos AD
   procedure Control_Modulo_MD;

end Procedimientos;

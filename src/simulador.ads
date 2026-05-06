-- ===========================================================================
--  Paquete  : Simulador
--  Archivo  : simulador.ads  (especificacion)
--  Practica : Control de Instalacion de Destilacion por Membranas
--
--  Encapsula el modelo matematico de la planta. Trabaja exclusivamente con
--  el tipo Iteracion_Registro definido en el paquete Datos.
--
--  Ecuaciones del modelo:
--    Ec.(2): Tt(k)  = (ST1(k-1) + ST2(k-1)) / 2
--    Ec.(1): ST2(k) = ST1(k-1) + [Beta*L_eq*SR1(k)*C] / [SC1(k)*C_p*Rho]
--                               - [H*(Tt(k)-ST4(k))*C]  / [SC1(k)*C_p*Rho]
--    Ec.(3): ST1(k) = ST2(k) - 10
--    Ec.(4): SD1(k) = 24 * (0.135 + 0.003*ST2(k-1) - 0.0203*ST3(k)
--                          - 0.001*SC2(k) + 0.00004*ST2(k-1)*SC2(k))
-- ===========================================================================

with Datos; use Datos;

package Simulador is

   -- -------------------------------------------------------------------------
   --  Funcion: Calcular_Paso
   --
   --  Ejecuta un paso de simulacion k aplicando las ecuaciones (1)-(4).
   --
   --  Parametros:
   --    Paso_Actual : campos leidos del fichero en el instante k
   --                  (N, SR1, ST4, ST3, SC1, SC2 deben estar rellenos)
   --    Paso_Previo : estado calculado en k-1
   --                  (ST1(k-1) y ST2(k-1) se usan para las ecuaciones)
   --
   --  Retorna:
   --    Iteracion_Registro con todos los campos de Paso_Actual mas:
   --      ST2(k), ST1(k), SD1(k)  calculados por las ecuaciones.
   -- -------------------------------------------------------------------------
   function Calcular_Paso
     (Paso_Actual : Iteracion_Registro;
      Paso_Previo : Iteracion_Registro)
      return Iteracion_Registro;

end Simulador;

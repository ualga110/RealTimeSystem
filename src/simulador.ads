-- ===========================================================================
--  Paquete  : Simulador
--  Archivo  : simulador.ads  (especificacion)
--  Practica : Control de Instalacion de Destilacion por Membranas
--
--  Encapsula el modelo matematico de la planta. Trabaja exclusivamente con
--  el tipo Iteracion_Registro definido en el paquete Datos, de modo que el
--  programa principal no necesita manejar tipos separados de entrada/salida.
-- ===========================================================================

with Datos; use Datos;

package Simulador is

   -- -------------------------------------------------------------------------
   --  Funcion: Calcular_Paso
   --
   --  Ejecuta un paso de simulacion k aplicando las ecuaciones (1)-(4).
   --
   --  Parametros:
   --    Paso_Actual : Iteracion_Registro
   --      Campos leidos: SR1(k), ST4(k), ST3(k), SC1(k), SC2(k), N(k)
   --    Paso_Previo : Iteracion_Registro
   --      Campos leidos: ST1(k-1), ST2(k-1)
   --
   --  Retorna:
   --    Iteracion_Registro con todos los campos de Paso_Actual mas:
   --      ST2(k), ST1(k), SD1(k)  calculados por las ecuaciones.
   --
   --  Orden de evaluacion:
   --    Ec.(2) -> Tt(k)  = (ST1(k-1) + ST2(k-1)) / 2          [local]
   --    Ec.(1) -> ST2(k) = ST1(k-1) + termino_solar - termino_calor
   --    Ec.(3) -> ST1(k) = ST2(k) - 10
   --    Ec.(4) -> SD1(k) = 24 * (0.135 + ...)
   -- -------------------------------------------------------------------------
   function Calcular_Paso
     (Paso_Actual : Iteracion_Registro;
      Paso_Previo : Iteracion_Registro)
      return Iteracion_Registro;

end Simulador;

--
--  Descripcion:
--    Este paquete encapsula el modelo matematico de la planta de destilacion
--    por membranas. Expone los tipos de datos necesarios y la funcion que
--    calcula un paso de simulacion dado el instante k.
--
--  Variables de estado:
--    ST1  : Temperatura de salida del colector solar   [deg C]
--    ST2  : Temperatura de entrada al colector solar   [deg C]
--    Tt   : Temperatura media del colector solar       [deg C]
--    SD1  : Caudal de destilado producido              [L/dia]
--
--  Entradas (medidas en cada instante k):
--    SR1  : Irradiancia solar                          [W/m2]
--    ST4  : Temperatura del agua de enfriamiento       [deg C]
--    ST3  : Temperatura de entrada al modulo           [deg C]
-- ===========================================================================

package Simulador is

   -- -------------------------------------------------------------------------
   --  Tipo: Datos_Entrada
   --  Agrupa las tres senales de entrada medidas en el instante k.
   -- -------------------------------------------------------------------------
   type Datos_Entrada is record
      SR1 : Float;   -- Irradiancia solar        [W/m2]
      ST4 : Float;   -- Temperatura enfriamiento [deg C]
      ST3 : Float;   -- Temperatura entrada mod. [deg C]
   end record;

   -- -------------------------------------------------------------------------
   --  Tipo: Resultados
   --  Agrupa las cuatro salidas calculadas en el instante k.
   -- -------------------------------------------------------------------------
   type Resultados is record
      ST2 : Float;   -- Temperatura entrada colector  [deg C]
      ST1 : Float;   -- Temperatura salida colector   [deg C]
      Tt  : Float;   -- Temperatura media colector    [deg C]
      SD1 : Float;   -- Caudal de destilado           [L/dia]
   end record;

   -- -------------------------------------------------------------------------
   --  Funcion: Calcular_Paso
   --
   --  Ejecuta un paso de simulacion k aplicando las ecuaciones (1)-(4).
   --
   --  Parametros:
   --    Entrada   : Datos_Entrada  -- SR1(k), ST4(k), ST3(k)
   --    ST1_Prev  : Float          -- ST1(k-1)
   --    ST2_Prev  : Float          -- ST2(k-1)
   --    SC1       : Float          -- Caudal colector primario  [L/min]
   --    SC2       : Float          -- Caudal colector secundario[L/min]
   --
   --  Retorna:
   --    Resultados con ST2(k), ST1(k), Tt(k), SD1(k)
   --
   --  Orden de evaluacion interno:
   --    1. Ec.(2): Tt(k)  = (ST1(k-1) + ST2(k-1)) / 2
   --    2. Ec.(1): ST2(k) = ST1(k-1) + num_solar/denom - num_calor/denom
   --    3. Ec.(3): ST1(k) = ST2(k) - 10
   --    4. Ec.(4): SD1(k) = 24 * ( 0.135 + 0.003*ST2(k-1)
   --                              - 0.0203*ST3(k) - 0.001*SC2(k)
   --                              + 0.00004*ST2(k-1)*SC2(k) )
   -- -------------------------------------------------------------------------
   function Calcular_Paso
     (Entrada  : Datos_Entrada;
      ST1_Prev : Float;
      ST2_Prev : Float;
      SC1      : Float;
      SC2      : Float)
      return Resultados;

end Simulador;

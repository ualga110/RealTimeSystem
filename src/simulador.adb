-- ===========================================================================
--  Paquete  : Simulador
--  Archivo  : simulador.adb  (cuerpo)
--  Practica : Control de Instalacion de Destilacion por Membranas
--
--  Las constantes fisicas (Beta, L_eq, H, C, C_p, Rho) se toman del paquete
--  Datos en lugar de definirse aqui, eliminando duplicacion.
--
--  Toda la aritmetica interna se realiza en Float. Los campos de tipo
--  Valor_Sensor (ST1, ST2, SD1) se convierten con Float() al operar y
--  se convierten de vuelta con Valor_Sensor() al guardar resultados.
-- ===========================================================================

with Datos; use Datos;
with gestion_archivos; use gestion_archivos;
with Ada.Text_IO;
use Ada.Text_IO;
package body Simulador is

   function Calcular_Paso
     (Paso_Actual : Iteracion_Registro;
      Paso_Previo : Iteracion_Registro)
      return Iteracion_Registro
   is
      Resultado : Iteracion_Registro := Paso_Actual;
      --  Se inicializa con Paso_Actual para conservar: N, SR1, ST4, ST3, SC1, SC2.
      --  Luego se sobreescriben ST2, ST1 y SD1 con los valores calculados.

      Denom  : Float;  -- SC1 * Cp * rho
      Tt_k   : Float;  -- Temperatura media del colector [degC]  (variable local)
      ST2_k  : Float;  -- ST2(k) calculado
      ST1_k  : Float;  -- ST1(k) calculado
      SD1_k  : Float;  -- SD1(k) calculado

   begin

      -- -----------------------------------------------------------------------
      --  Ec.(2): Tt(k) = (ST1(k-1) + ST2(k-1)) / 2
      --  Usa los estados del paso ANTERIOR (Paso_Previo).
      -- -----------------------------------------------------------------------
      Tt_k := (Float (Paso_Previo.ST1) + Float (Paso_Previo.ST2)) / 2.0;

      -- -----------------------------------------------------------------------
      --  Ec.(1): ST2(k) = ST1(k-1)
      --                    + [Beta * L_eq * SR1(k) * C] / [SC1(k) * C_p * Rho]
      --                    - [H * (Tt(k) - ST4(k)) * C] / [SC1(k) * C_p * Rho]
      -- -----------------------------------------------------------------------
      Denom := Float (Paso_Actual.SC1) * C_p * Rho;

      ST2_k :=   Float (Paso_Previo.ST1)
               + (Beta * L_eq * Float (Paso_Actual.SR1) * C) / Denom
               - (H    * (Tt_k - Float (Paso_Actual.ST4)) * C) / Denom;

      -- -----------------------------------------------------------------------
      --  Ec.(3): ST1(k) = ST2(k) - 10
      -- -----------------------------------------------------------------------
      ST1_k := ST2_k - 10.0;

      -- -----------------------------------------------------------------------
      --  Ec.(4): SD1(k) = 24 * ( 0.135
      --                         + 0.003   * ST2(k-1)
      --                         - 0.0203  * ST3(k)
      --                         - 0.001   * SC2(k)
      --                         + 0.00004 * ST2(k-1) * SC2(k) )
      --  Nota: usa ST2(k-1) = Paso_Previo.ST2
      -- -----------------------------------------------------------------------
      SD1_k := 24.0 * (  0.135
                        + 0.003   * Float (Paso_Previo.ST2)
                        - 0.0203  * Float (Paso_Actual.ST3)
                        - 0.001   * Float (Paso_Actual.SC2)
                        + 0.00004 * Float (Paso_Previo.ST2) * Float (Paso_Actual.SC2));

      -- -----------------------------------------------------------------------
      --  Guardar resultados en el registro de salida
      -- -----------------------------------------------------------------------
      Resultado.ST2 := Valor_Sensor (ST2_k);
      Resultado.ST1 := Valor_Sensor (ST1_k);
      Resultado.SD1 := Valor_Sensor (SD1_k);

      -- -----------------------------------------------------------------------
      --  Registrar datos en el log
      -- -----------------------------------------------------------------------
      Registrar_Datos (Resultado);

      -- -----------------------------------------------------------------------
      --  Verificar condiciones de alarma
      -- -----------------------------------------------------------------------
      if Float (Resultado.ST1) > 90.0 then
         New_Line;
         Put_Line("*ALERTA*: Temperatura demasiado alta");
         Put_Line("La alerta de la iteración " & N_Iteracion'Image(Resultado.N) & " ha sido enviada al log de alarmas");
         Registrar_Alarma (Resultado.N, "Temperatura demasiado alta");
      end if;

      if Float (Resultado.SD1) < 20.0 then
         New_Line;
         Put_Line("*ALERTA*: Caudal de destilado bajo");
         Put_Line("La alerta de la iteración " & N_Iteracion'Image(Resultado.N) & " ha sido enviada al log de alarmas");

         Registrar_Alarma (Resultado.N, "Caudal de destilado bajo");
      end if;

      return Resultado;

   end Calcular_Paso;

end Simulador;

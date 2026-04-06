with Datos; use Datos;
with gestion_archivos; use gestion_archivos;
with Ada.Text_IO;
use Ada.Text_IO;
package body Simulador is

   -- Al tener una variable con la cual obtenemos todas las variables de una iteración,
   -- únicamente necesitamos el paso actual y el previo para obtener todas las variables
   function Calcular_Paso
     (Paso_Actual : Iteracion_Registro;
      Paso_Previo : Iteracion_Registro)
      return Iteracion_Registro
   is
      -- Se inicializa con Paso_Actual para conservar las variables de este paso
      -- y después actualizarlas con los valores calculados
      Resultado : Iteracion_Registro := Paso_Actual;

      Denom  : Float;
      Tt_k   : Float;
      ST2_k  : Float;
      ST1_k  : Float;
      SD1_k  : Float;

   begin

      -- Ec(2): Tt(k) = (ST1(k-1) + ST2(k-1)) / 2
      Tt_k := (Float (Paso_Previo.ST1) + Float (Paso_Previo.ST2)) / 2.0;

      -- Ec(1): ST2(k) = ST1(k-1)
      --                   + [Beta * L_eq * SR1(k) * C] / [SC1(k) * C_p * Rho]
      --                   - [H * (Tt(k) - ST4(k)) * C] / [SC1(k) * C_p * Rho]
      Denom := Float (Paso_Actual.SC1) * C_p * Rho;

      ST2_k :=   Float (Paso_Previo.ST1)
               + (Beta * L_eq * Float (Paso_Actual.SR1) * C) / Denom
               - (H    * (Tt_k - Float (Paso_Actual.ST4)) * C) / Denom;

      -- Ec(3): ST1(k) = ST2(k) - 10
      ST1_k := ST2_k - 10.0;

      -- Ec(4): SD1(k) = 24 * ( 0.135
      --                        + 0.003   * ST2(k-1)
      --                        - 0.0203  * ST3(k)
      --                        - 0.001   * SC2(k)
      --                        + 0.00004 * ST2(k-1) * SC2(k) )
      SD1_k := 24.0 * (  0.135
                        + 0.003   * Float (Paso_Previo.ST2)
                        - 0.0203  * Float (Paso_Actual.ST3)
                        - 0.001   * Float (Paso_Actual.SC2)
                        + 0.00004 * Float (Paso_Previo.ST2) * Float (Paso_Actual.SC2));

      Resultado.ST2 := Valor_Sensor (ST2_k);
      Resultado.ST1 := Valor_Sensor (ST1_k);
      Resultado.SD1 := Valor_Sensor (SD1_k);

      -- Registrar datos en el archivo archivos/data_log.txt
      Registrar_Datos (Resultado);

      -- Si necesitamos poner alguna alarma
      if Float (Resultado.ST2) > 95.0 then
         Registrar_Alarma (Resultado.N, "Temperatura demasiado alta");
      end if;

      return Resultado;

   end Calcular_Paso;

end Simulador;

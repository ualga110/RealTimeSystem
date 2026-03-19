with Datos; use Datos;

package body Controladores is

   function Calcular_SC1 (SR1    : in Valor_Radiacion;
                          ST4    : in Valor_Temperatura;
                          ST1_Prev : in Float;
                          ST2_Prev : in Float)
                          return Valor_Caudal is
      
      Tt_k : Float;
      Numerador : Float;
      Denominador : Float;
      SC1_Calculado : Float;
      
      -- Es para normalizar SC1 como resultado
      -- Si SC1 < 7.5 => SC1 := 7.5
      -- Si SC1 > 25.0 => SC1 := 25
      procedure Normalizar_SC1(SC1_Calculado : in out Float) is
      begin
               
         if SC1_Calculado < 7.5 then
            SC1_Calculado := 7.5;
         elsif SC1_Calculado > 25.0 then
            SC1_Calculado := 25.0;
         end if;

      end Normalizar_SC1;
      
   begin
      Tt_k := (ST1_Prev + ST2_Prev) / 2.0;
      
      Numerador := C * (Beta * L_eq * Float(SR1) - H * (Tt_k - Float(ST4)));
      Denominador := (ST2_Optimo - ST1_Prev) * C_p * Rho;
      
      
      -- Por si el denominador es cero
      if Denominador = 0.0 then
         SC1_Calculado := 7.5;
      else
         SC1_Calculado := Numerador / Denominador;
      end if;
      
      Normalizar_SC1(SC1_Calculado);
      
      return Valor_Caudal(SC1_Calculado);
   end Calcular_SC1;

   function Calcular_SC2 (ST3    : in Valor_Temperatura;
                          ST2_Prev : in Float)
                          return Valor_Caudal is
      
      Numerador : Float;
      Denominador : Float;
      SC2_Calculado : Float;
      SC2_Lim : Float;
      
      
      -- Es para normalizar SC2 como resultado
      -- Si SC2 < 150.0 => SC2 := 150.0
      -- Si SC2 > 620.0 => SC2 := 620.0      
      procedure Normalizar_SC2(SC2_Calculado : in out Float)
      is
      begin
         
         if SC2_Calculado < 150.0 then
            SC2_Calculado := 150.0;
         elsif SC2_Calculado > 620.0 then
            SC2_Calculado := 620.0;
         end if;    
      
      end Normalizar_SC2;
      
   begin
      Numerador := Float(23.0/24.0) - 0.135 - (0.003 * ST2_Prev) + Float(0.0203 * ST3);
      Denominador := -0.0001 + (0.00004 * ST2_Prev);
      
      if Denominador = 0.0 then
         SC2_Calculado := 620.0;
      else
         SC2_Calculado := Numerador / Denominador;
      end if;
      
      Normalizar_SC2(SC2_Calculado);
      
      return Valor_Caudal(SC2_Calculado);
   end Calcular_SC2;

end Controladores;

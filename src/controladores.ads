with Datos; use Datos;

package Controladores is

   -- Los valores óptimos para calcular SC1 y SC2
   ST2_Optimo : constant Float := 78.0;
   SD1_Optimo : constant Float := 23.0;

   function Calcular_SC1 (SR1    : in Valor_Radiacion;
                          ST4    : in Valor_Temperatura;
                          ST1_Prev : in Float;
                          ST2_Prev : in Float)
                          return Valor_Caudal;

   function Calcular_SC2 (ST3    : in Valor_Temperatura;
                          ST2_Prev : in Float)
                          return Valor_Caudal;


end Controladores;

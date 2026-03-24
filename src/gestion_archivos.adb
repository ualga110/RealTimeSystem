with Ada.Directories;
with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Float_Text_IO;
use Ada.Directories;
use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Ada.Float_Text_IO;

package body gestion_archivos is

   F_Entrada : File_Type;

   procedure Abrir_Entrada is
   begin
      if not Exists(Archivo_Entrada) then
         raise Program_Error with "No se encuentra el archivo de entrada: input.txt";
      end if;
      Open(F_Entrada, In_File, Archivo_Entrada);
   end Abrir_Entrada;

   procedure Cerrar_Entrada is
   begin
      Close(F_Entrada);
   end Cerrar_Entrada;

   procedure Leer_Entrada (Iteracion : out N_Iteracion;
                          SR1         : out Valor_Radiacion; 
                          ST4         : out Valor_Temperatura; 
                          ST3         : out Valor_Temperatura;
                          Fin_Archivo : out Boolean) is
      I : Integer;
      S1, T4, T3 : Float;
   begin
      if End_Of_File(F_Entrada) then
         Fin_Archivo := True;
         return;
      end if;
      
      Get(F_Entrada, I);
      Iteracion := N_Iteracion(I);
      
      Get(F_Entrada, S1);
      SR1 := Valor_Radiacion(S1);
      
      Get(F_Entrada, T4);
      ST4 := Valor_Temperatura(T4);
      
      Get(F_Entrada, T3);
      ST3 := Valor_Temperatura(T3);
      
      Fin_Archivo := End_Of_File(F_Entrada);
   end Leer_Entrada;
   
   procedure Crear_Cabecera_Log is
      Fichero : File_Type;
   begin
      Create(Fichero, Out_File, Archivo_Log);
      Put(Fichero, "   N |     ST1 |     ST2 |     ST3 |     ST4 |     SC1 |     SC2 |     SR1 |     SD1");
      New_Line(Fichero);
      Put(Fichero, "-----|---------|---------|---------|---------|---------|---------|---------|---------");
      New_Line(Fichero);
      Close(Fichero);
   end Crear_Cabecera_Log;
   
   procedure Crear_Cabecera_Alarm is
      Fichero : File_Type;
   begin
      Create(Fichero, Out_File, Archivo_Alarm);
      Put(Fichero, "   N | MENSAJE");
      New_Line(Fichero);
      Put(Fichero, "-----|----------------");
      New_Line(Fichero);
      Close(Fichero);
   end Crear_Cabecera_Alarm;
   
   procedure Registrar_Datos (Fila : in Iteracion_Registro) is
      Fichero : File_Type;
   begin
      if Exists(Archivo_Log) then
         Open(Fichero, Append_File, Archivo_Log);
      else
         Crear_Cabecera_Log;
         Open(Fichero, Append_File, Archivo_Log);
      end if;
      
      Ada.Integer_Text_IO.Put(Fichero, Integer(Fila.N), Width => 4);
      Put(Fichero, " | ");
      Ada.Float_Text_IO.Put(Fichero, Float(Fila.ST1), Fore => 4, Aft => 2, Exp => 0);
      Put(Fichero, " | ");
      Ada.Float_Text_IO.Put(Fichero, Float(Fila.ST2), Fore => 4, Aft => 2, Exp => 0);
      Put(Fichero, " | ");
      Ada.Float_Text_IO.Put(Fichero, Float(Fila.ST3), Fore => 4, Aft => 2, Exp => 0);
      Put(Fichero, " | ");
      Ada.Float_Text_IO.Put(Fichero, Float(Fila.ST4), Fore => 4, Aft => 2, Exp => 0);
      Put(Fichero, " | ");
      Ada.Float_Text_IO.Put(Fichero, Float(Fila.SC1), Fore => 4, Aft => 2, Exp => 0);
      Put(Fichero, " | ");
      Ada.Float_Text_IO.Put(Fichero, Float(Fila.SC2), Fore => 4, Aft => 2, Exp => 0);
      Put(Fichero, " | ");
      Ada.Float_Text_IO.Put(Fichero, Float(Fila.SR1), Fore => 4, Aft => 2, Exp => 0);
      Put(Fichero, " | ");
      Ada.Float_Text_IO.Put(Fichero, Float(Fila.SD1), Fore => 4, Aft => 2, Exp => 0);
      New_Line(Fichero);
      
      Close(Fichero);
   end Registrar_Datos;
   
   procedure Registrar_Alarma (K : in N_Iteracion; Mensaje : in String) is
      Fichero : File_Type;
   begin
      if not Exists(Archivo_Alarm) then
         Crear_Cabecera_Alarm;
      end if;
      
      Open(Fichero, Append_File, Archivo_Alarm);

      Ada.Integer_Text_IO.Put(Fichero, Integer(K), Width => 4);
      Put(Fichero, " | ");
      Put(Fichero, Mensaje);
      New_Line(Fichero);
      
      Close(Fichero);
   end Registrar_Alarma;
   
   procedure Comprobar_Archivos is
   begin
      if not Exists(Archivo_Entrada) then
         raise Program_Error with "No se encuentra el archivo de entrada: input.txt";
      end if;
   end Comprobar_Archivos;

end gestion_archivos;

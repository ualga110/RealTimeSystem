package Semaphores is

   protected type Semaphore(Initial : Integer := 1) is
      entry Wait;
      procedure Signal;
   private
      Value : Integer := Initial;
   end Semaphore;

end Semaphores;

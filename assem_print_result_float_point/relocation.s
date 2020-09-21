 AREA   mem_Relocation, CODE, READONLY
   ;EQU      &0
;   SWI_Exit      EQU      &11   
   
   EXPORT Relocation 
      
   ENTRY
Relocation
   
   LDR R0, Image_Address   ;r0=0X407E9000(last address of original image)
   LDR R1, New_Address      ;r1= 0X4086FE00(last address of relocated image)
   LDR R2, last_Address
   
    MOV R8, #128<<2         ;r8=128 is  movw-jmp size
   
LOOPB                  ;loop count reset

   MOV R7, #0            ;r7=480 is move-set count
   CMP R1,R2      ;if r1<0x40002000 
                     
   BLE endl            ;end
   
   ;else goto loop 
   
LOOP 
   
   ;LDMDB R0!,{R3-R6} 
   ;LDMDB R0!,{R9-R12} 
   LDMDB R0!,{R3-R6,R9-R12}       ;get 4 data (RGBA x4=16B)
   
   ;STMFD R1!, {r3-r6}
   ;STMFD R1!, {r9-r12}
   STMFD R1!, {R3-R6,R9-R12}        ;store 4data 
   ADD R7,R7,#1          ;r7--;
   CMP R7,#240         ;if (r7<480)
   BLT LOOP            ;goto loop
   
   ;else (r7>=480) == data copy end
   
   SUB R1,R1,R8         ;r7-=128
   B LOOPB               



endl

   BX lr
   
Image_Address DCD 0X407E9000
New_Address DCD 0X4086FE00
last_Address DCD  0X40002000

   END
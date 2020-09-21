

 AREA convolution, CODE, READONLY
      EXPORT Convolution
        
   ENTRY                                                

Convolution

; r0 = gray [][]
; r1 = conv [][]
; 
; w= { 
;    {125,-140,50},
;   {-140,0,-75},
;   {50,-75,125}
;   }
;
; 
; {128, -143, -77, 51} it is *1024!
; so, we use r2=128, r3=-143, r4=-77, r5=51
; r6 -> res
; r7, r8, r9 -> ldm register
; r10 : sum
; r11 : i
; r12 : j
; r13 : 1080

; suppose that already initiailize r0-r6

   LDR r0, VALUEG;
   LDR r1, VALUEC;
   LDR r13, VALUEE;
   
   MOV r2, #125;
   MOV r3, #-140;
   MOV r4, #-75;
   MOV r5, #50;
   
   MOV r11, #1;
   MOV r12, #1;

LOOP
   MOV r10, #0; sum=0
   
   LDM r0, {r7-r9};
   MUL r6, r7, r2; no constant... no same register..
   ADD r10, r10,r6;
   MUL r6 ,r8, r3;
   ADD r10, r10, r6;
   MUL r6,r9, r5;
   ADD r10, r10, r6;
   
   ADD r0, r0, #0x2000;
   LDM r0, {r7-r9};
   MUL r6, r7, r3;
   ADD r10, r10, r6;
   ; finally r8 * 0 is zero. so, we won't calculate
   MUL r6 ,r9, r4;
   ADD r10, r10, r6;
   
   ADD r0, r0, #0x2000;
   LDM r0, {r7-r9};
   MUL r6, r7, r5;
   ADD r10, r10, r6;
   MUL r6 ,r8, r4;
   ADD r10, r10, r6;
   MUL r6 ,r9, r2;
   ADD r10, r10, r6;
   
   SUB r0, r0, #0x4000;
   ADD r0, r0, #4;
   
   CMP r10, #0; sum <0
   MOVLT r10, #0; sum=0
   
   ;MOV r10, r10, LSR #10; sum=sum/1024 No we don't do that
   STR r10, [r1], #4 ; result stored at conv[][], post-index
   
   
   CMP r12, #1920; j vs 1920
   ADDLT r12, r12, #1; j++
   BLT LOOP;
   
   
   CMP r11, r13; i vs 1080
   ADDLT r11, r11, #1; i++
   ADDLT r1, r1, #128<<2 ; no padding
   MOVLT r12, #1; j make 1
   ADDLT r0, r0, #128<<2 ; yes padding
   BLT LOOP;
   
   BX LR;
 
VALUEG   DCD 0x50000000
VALUEC   DCD 0x60000000 
VALUEE   DCD 0x438;1080
   END
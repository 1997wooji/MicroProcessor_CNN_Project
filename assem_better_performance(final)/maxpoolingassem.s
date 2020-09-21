
   AREA   maxpooling, CODE, READONLY
      
      EXPORT MaxPooling
      
   ENTRY                                                

MaxPooling

; r0 = conv address
; r1 = result address
; {r2-r5}
; {r6-r9}, r2 max, r4 max

; {r3, r5, r6, r7}
; {r8-r11}, r5 max, r6 max
; r12 i
; r13 j


   LDR r0,VALUE1 ; conv
  LDR r1, VALUE2 ; result
   MOV r12, #1;
   MOV r13, #1;
 
LOOP1
   ;first, second block
   ADD r0, r0, #0x2000;
   LDMIA r0,{r6-r9}; is it right?
   SUB r0, r0, #0x2000;
   LDMIA r0!, {r2-r5};
  
   ;first block
   CMP r2, r3;
   MOVLT r2, r3; r2<r3, then make r2 big thing
   
   CMP r6, r7;
   MOVLT r6, r7; r6<r7, then make r6 big thing
   
   CMP r2, r6;
   MOVLT r2, r6; first block max stored at r2
  
   ;second block
   CMP r4, r5;
   MOVLT r4, r5; r4<r5, then make r4 big thing
   
   CMP r8, r9;
   MOVLT r8, r9; r8<r9, then make r8 big thing
   
   CMP r4, r8;
   MOVLT r4, r8; second block max stored at r4
   
   ;thrid, fourth block
   ADD r0, r0, #0x2000; 2048*4!!!!!!!!!! *4!!!!!!!!!1
   LDMIA r0, {r8-r11}; is it right?
   SUB r0, r0, #0x2000;
   LDMIA r0!, {r3, r5-r7};
  
   ;thrid block
   CMP r3, r5;
   MOVGE r5, r3; ***** r5<r3, then make r5 big thing
   
   CMP r8, r9;
   MOVLT r8, r9; r8<r9, then make r8 big thing
   
   CMP r5, r8;
   MOVLT r5, r8; first block max stored at r5
  
   ;fourth block
   CMP r6, r7;
   MOVLT r6, r7; r4<r5, then make r6 big thing
   
   CMP r10, r11;
   MOVLT r10, r11; r10<r11, then make r10 big thing
   
   CMP r6, r10;
   MOVLT r6, r10; second block max stored at r6
   
   MOV r2, r2, LSR #10; sum=sum/1024
   MOV r4, r4, LSR #10; sum=sum/1024
   MOV r5, r5, LSR #10; sum=sum/1024
   MOV r6, r6, LSR #10; sum=sum/1024
   
   STMIA r1!, {r2, r4-r6}; stored at result[][]
   
   CMP r13, #0xF0; r13(j) compare 1920/8=240
   ADDLT r13, r13, #1; j++
   BLT LOOP1;
   
   ;if r13==240, then i++
   CMP r12, #0x21C; r12(i) compare 1080/2=540
   ADDLT r0, r0, #0x2200; 128*4 + 2048*4
   ADDLT r12, r12, #1;
   MOVLT r13, #1;
   BLT LOOP1;
   
   BX LR;

VALUE1 DCD       &60000000 ; conv[][] address
VALUE2 DCD       &70000000 ; result[][] address
      
   END
      
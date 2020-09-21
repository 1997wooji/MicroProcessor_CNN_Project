   AREA gray,CODE,READONLY   
      EXPORT Grayscale
      
   ENTRY 
   ;0x50871e00 <-final grayscale
   ;0x50873dfc <-real final
Grayscale

;****padding******
   LDR r0,VALUE1 ;address 
   LDR r11,start_address ;50000004
   MOV r1,#0 ;r1=0 for initialize 0 (when STM, use r1~r8)
   MOV r2,#0 ;r2=0
   MOV r3,#0 ;r3=0
   MOV r4,#0 ;r4=0
   MOV r5,#0 ;r5=0
   MOV r6,#0 ;r6=0
   MOV r7,#0 ;r7=0
   MOV r8,#0 ;r8=0
   
   LDR r9,row ;1082
   SUB r10,r11,#4 ;r11=r10 for loop0_1 50000000
   LDR r12,final_address ;final line 00000000....000
   MOV r13,#0 ;counter
loop0
   STM r11!,{r1,r2,r3,r4,r5,r6,r7,r8} ;first row 0000...00
   STM r12!,{r1,r2,r3,r4,r5,r6,r7,r8} ;final row 0000...00
   ADD r13,r13,#1 ;counter=counter+1
   CMP r13,#240 ;576
   BLT loop0
   
   MOV r13,#0 ;counter reset
   
   LDR r2,plus_address
loop0_1   
   STR r1,[r10,r2]!
   STR r1,[r11,r2]!
   ADD r13,r13,#1
   CMP r13,r9;compare1082
   BLT loop0_1
   
   SUB r9,r9, #2;
;**********grayscale*******************
   LDR r13,save_address 
   MOV r12,#0xff ;for and (0x000000ff)
   MOV r11,#1 ;counter2 (cheak 1080)
   
loop1
   
   MOV r10,#0 ;counter (cheak 1920)
loop
   LDM r0!,{r1,r2,r3,r4} ;load data
   ADD r10,r10,#4 ;r10=r10+4 (compare with 1920 later)
   
;**************r1**************
   AND r5,r12,r1,LSR #8 ;byte->bit(R)
   AND r6,r12,r1,LSR #16 ;byte->bit(G)
   AND r7,r12,r1,LSR #24 ;byte->bit(B)
   
   CMP r5,r6 ;compare R,G
   MOVGE r8,r5
   MOVLT r8,r6
   MOVLT r6,r5
   CMP r7,r8
   MOVGE r8,r7
   CMP r6,r7
   MOVGE r6,r7
   ADD r1,r8,r6 ;MAX+MIN
   MOV r1,r1,LSR #1 ;L=(MAX+MIN)/2
   
   
;**************r2**************
   
   AND r5,r12,r2,LSR #8  ;byte->bit(R)
   AND r6,r12,r2,LSR #16 ;byte->bit(G)
   AND r7,r12,r2,LSR #24 ;byte->bit(B)
   
   CMP r5,r6 ;compare R,G
   MOVGE r8,r5
   MOVLT r8,r6
   MOVLT r6,r5
   CMP r7,r8
   MOVGE r8,r7
   CMP r6,r7
   MOVGE r6,r7
   ADD r2,r8,r6 ;MAX+MIN
   MOV r2,r2,LSR #1 ;L=(MAX+MIN)/2
   
   
   
;**************r3**************
   
   AND r5,r12,r3,LSR #8  ;byte->bit(R)
   AND r6,r12,r3,LSR #16 ;byte->bit(G)
   AND r7,r12,r3,LSR #24 ;byte->bit(B)
   
   CMP r5,r6 ;compare R,G
   MOVGE r8,r5
   MOVLT r8,r6
   MOVLT r6,r5
   CMP r7,r8
   MOVGE r8,r7
   CMP r6,r7
   MOVGE r6,r7
   ADD r3,r8,r6 ;MAX+MIN
   MOV r3,r3,LSR #1 ;L=(MAX+MIN)/2
   
   
   
   
;**************r4**************

   AND r5,r12,r4,LSR #8  ;byte->bit(R)
   AND r6,r12,r4,LSR #16 ;byte->bit(G)
   AND r7,r12,r4,LSR #24 ;byte->bit(B)
   
   CMP r5,r6 ;compare R,G
   MOVGE r8,r5
   MOVLT r8,r6
   MOVLT r6,r5
   CMP r7,r8
   MOVGE r8,r7
   CMP r6,r7
   MOVGE r6,r7
   ADD r4,r8,r6 ;MAX+MIN
   MOV r4,r4,LSR #1 ;L=(MAX+MIN)/2
   
   
;*******************************
   STM r13!,{r1,r2,r3,r4} ;store
   
   CMP r10,#1920
   BNE loop
   ADD r13,r13,#128<<2 ;blank space 
   ADD r0,r0,#128<<2 ;blank space 
   ADD r11,r11,#1 ;r11=r11+1 (compare with 1080 later)
   CMP r11,r9 ;compare with 1080
   BLE loop1
   
   BX lr
   
VALUE1 DCD   &40000000   
row DCD &0000043A ;1082
save_address DCD &50002004
start_address DCD &50000004
final_address DCD &50872004
count1 DCD &281 ;1923/3=641
plus_address DCD &2000

   END
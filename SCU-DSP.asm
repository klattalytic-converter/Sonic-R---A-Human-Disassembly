
            MOV     #2,CT0
            MOV     M0,RA0          ;MATRIX POINTER
            DMA     D0,M0,#4*3      ;READ MATRIX

NOMATRIX:   MOV     #0,CT0          
            MOV     #63,CT1         

            MOV     MC0,WA0         ;RESULT POINTER
            MOV     MC0,RA0         ;MODEL DATA
            DMA     D0,M1,#4*3+1    ;READ FIRST POLY+SIZE
DMA_WAIT:   JMP     T0,DMA_WAIT     ;WAIT FOR DATA TO ARRIVE

            MOV     #63,CT1
            MOV     MC1,LOP

            MOV     LOOP,TOP

;START COMPUTING SUMS OF PRODUCTS AND STORING RESULTS OF 1 POLY
LOOP:
;------------------------------
;           BUFFER 1
;------------------------------
;-------
;POINT 1
;-------            
            MOV MC1,X           MOV MC0,Y           MOV #0,CT3

            MOV MC1,X MOV MUL,P MOV MC0,Y CLR A     MOV #0,CT2
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y MOV ALU,A MOV #0,CT1
        AD2           MOV MUL,P MOV MC0,Y MOV ALU,A MOV #64,RX
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y MOV ALU,A
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y CLR A     MOV ALH,MC3
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y MOV ALU,A MOV #3,CT1
        AD2           MOV MUL,P MOV MC0,Y MOV ALU,A MOV #64,RX
        AD2           MOV MUL,P           MOV ALU,A MOV #2,CT0
        AD2 MOV MC1,X           MOV MC0,Y           MOV ALH,MC3
;-------
;POINT 2
;-------
            MOV MC1,X MOV MUL,P MOV MC0,Y CLR A
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y MOV ALU,A MOV #3,CT1
        AD2           MOV MUL,P MOV MC0,Y MOV ALU,A MOV #64,RX
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y MOV ALU,A
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y CLR A     MOV ALH,MC3
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y MOV ALU,A MOV #3,CT1
        AD2           MOV MUL,P MOV MC0,Y MOV ALU,A MOV #64,RX
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y MOV ALU,A
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y CLR A     MOV ALH,MC3
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y MOV ALU,A MOV #6,CT1
        AD2           MOV MUL,P MOV MC0,Y MOV ALU,A MOV #64,RX
        AD2           MOV MUL,P           MOV ALU,A MOV #2,CT0
        AD2 MOV MC1,X           MOV MC0,Y           MOV ALH,MC3

                DMA     D0,M2,#4*3      ;READ BUFFER 2 POLY
;-------
;POINT 3
;-------
            MOV MC1,X MOV MUL,P MOV MC0,Y CLR A     MOV #0,CT2
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y MOV ALU,A MOV #6 CT1
        AD2           MOV MUL,P MOV MC0,Y MOV ALU,A MOV #64,RX
        AD2 MOV MC1,X MOV MUL,P MOV MC0,Y MOV ALU,A

;               Environment map assembler code
;------------------------------------------------------------------------------------------             
                section code

                public on

screenw:        equ     128
screenh:        equ     128
per:            equ     200

;------------------------------------------------------------------------------------------
;               standard setup                                                             
;------------------------------------------------------------------------------------------
                mov     r4,@-r15                ;p0
                mov     r5,@-r15                ;p1
                mov     r6,@-r15                ;p2
                mov     r7,@-r15                ;texture pointer
                mov     r8,@-r15
                mov     r9,@-r15
                mov     r10,@-r15
                mov     r11,@-r15
                mov     r12,@-r15
                mov     r13,@-r15
                mov     r14,@-r15


                mov.l     @r15+,r14
                mov.l     @r15+,r13
                mov.l     @r15+,r12
                mov.l     @r15+,r11
                mov.l     @r15+,r10
                mov.l     @r15+,r9
                mov.l     @r15+,r8
                mov.l     @r15+,r7
                mov.l     @r15+,r6
                mov.l     @r15+,r5
                mov.l     @r15+,r4
                rts
                nop
;------------------------------------------------------------------------------------------
;               Transform to screen                                                             
;------------------------------------------------------------------------------------------
transscreen:    mov     r4,@-r15                ;pV
                mov     r5,@-r15                ;tempmat
                mov     r6,@-r15                ;counter
                mov     r7,@-r15                
                mov     r8,@-r15
                mov     r9,@-r15
                mov     r10,@-r15
                mov     r11,@-r15
                mov     r12,@-r15
                mov     r13,@-r15
                mov     r14,@-r15

                mov     =per,r0                 ;per
                mov     =screenw/2,r2           ;swidth/2
                mov     =screenh/2,r3           ;sheight/2
                mov     (36,r5),r10             ;transx
                mov     (40,r5),r11             ;transy
                mov     (44,r5),r12             ;transz
                mov     =$100000,r13
                mov     =$ffffff00,r14          ;divide address

@loop           clrmac
                mac     @r4+,@r5+
                mac     @r4+,@r5+
                mac     @r4+,@r5+
                sub     #12,r4
                sts     macl,r8
                dmuls   r8,r13
                sts     mach,r8                 ;/4096
                clrmac
                mac     @r4+,@r5+
                add     r10,r8                  ;x
                mac     @r4+,@r5+
                mac     @r4+,@r5+
                sub     #12,r4
                sts     macl,r8
                dmuls   r8,r13
                sts     mach,r8                 ;/4096
                clrmac
                mac     @r4+,@r5+
                add     r11,r9                  ;y
                mac     @r4+,@r5+
                mac     @r4+,@r5+
                sub     #12,r4
                sts     macl,r7
                dmuls   r7,r13
                sub     #36,r5
                sts     #mach,r7                ;/4096
                add     r12,r7                  ;z

                mov     r8,(24,r4)              ;pV.xT
                mov     r9,(28,r4)              ;pV.yT

                cmp/pz  r7                      ;z<0
                bf/s    @ltzero
                mov     r7,(32,r4)              ;pV.zT

                muls    r8,r0                   ;x*per
                add     r0,r7                   ;z+per
                sts     macl,r8
                mov     r7,@(divu_jr,r14)       ;per+z
                mov     r8,@(divu_hr132,r14)    ;per*x
                mul     r9,r0
                mov     @(divu_rsr,r14),r8
                sts     macl,r9
                mov     r9,@(divu_hr132,r14)    ;per*y
                add     
                mov     
                add     

                mov     r8,(36,r4)              ;pV.xS
                mov     r9,(40,r4)              ;pV.yS
                bra     @ok
                mov     #1,r8

@ltzero         mov     #0,r8
@ok:            mov     r8,(56,r4)              ;pV.f    

                dt      r6
                bf/s    @loop
                add     #64,r4 

                mov     @r15+,r14
                mov     @r15+,r13
                mov     @r15+,r12 
                mov     @r15+,r11
                mov     @r15+,r10
                mov     @r15+,r9
                mov     @r15+,r8
                mov     @r15+,r7
                mov     @r15+,r6
                mov     @r15+,r5
                mov     @r15+,r4
                rts
                nop

                .align  4
                littab

;------------------------------------------------------------------------------------------
;               clear bytescreen                                                             
;------------------------------------------------------------------------------------------
clrscr:         mov     r4,r0
                mov     #0,r1
                mov     #1,r2
                shll8   r2                      ;256
@loop:
                rept    15
                mov     r1,@-r0
                endr    
                dt      r2
                bf/s    @loop
                mov     r1,@-r0
                rts
                nop
clrscr2:        
                mov     =$ffffff90,r0
                mov     #1
                mov

                mov     =@blank,r1
                mov     r1,@(0,r0)              ;source address
                mov     r4,@(4,r0)              ;dest address
                mov     =4096*48,r1
                mov     r1,@(8,r0)              ;count

                mov     =%0100101000010001,r1
                mov     r1,@(12,r0)             ;channel control

                rts
                nop
                dc.l    $12345678

;------------------------------------------------------------------------------------------
;               sort emap polys                                                       
;------------------------------------------------------------------------------------------ 
sortemap:       mov     r4,@-r15                ;ZTable
                mov     r5,@-r15                ;pModel
                mov     r6,@-r15                
                mov     r7,@-r15                
                mov     r8,@-r15
                mov     r9,@-r15
                mov     r10,@-r15
                mov     r11,@-r15
                mov     r12,@-r15
                mov     r13,@-r15
                mov     r14,@-r15
;clear z-table
                mov     #8,r0
                mov     #0,r1
@clear:         
                rept    7
                mov     r1,@-r4
                endr
                dt      r0
                bf/s    @clear
                mov     r1,@-r4

                mov     #-1,r14
                shll8   r14                     ;point at divide addresses
                mov     =384,r6
                mov.l   r6,@(divu_jr,r14)       ;384

                mov     (32,r5),r6              ;number of triangles

                mov     =280,r6
                mov     (36,r5),r13
                mov     (40,r5),r12

@loop:          mov     @(0,r12),r1
                mov     @(4,r12),r2
                mov     @(8,r15),r3
                shll8   r1
                shlr2   r1
                add     r13,r1
                shll8   r2
                shlr2   r2
                add     r13,r2
                shll8   r3
                shlr2   r3
                add     r13,r3

;check for vertex behind camera
                mov     (56,r1),r0
                mov     (56,r2),r11
                add     r11,r0
                cmp/eq  #0,r0
                bt/s    @ignore

                mov     (36,r2),r0             ;p1.xS
                mov     (40,r2),r11            ;p1.yS
                mov     (36,r1),r7             ;p0.xS
                sub     r0,r7                  ;sx
                mov     (40,r1),r8             ;p0.yS
                sub     r11,r8                 ;sy
                mul     (36,r3),r9             ;p2.xS
                sub     r0,r9                  ;tx
                mul     r9,r8                  ;tx*sy
                mov     (40,r3),r10            ;p2.yS
                sub     r11,r10                ;ty
                sts     macl,r0
                mul     r7,r10                 ;sx*ty
                sts     macl,r11
                sub     r11,r0
                cmp/pl  r0
                bf/s    @ignore
;

                
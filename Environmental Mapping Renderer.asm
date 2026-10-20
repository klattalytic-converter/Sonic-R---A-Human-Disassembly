;------------------------------------------------------------------------------------------
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
;find z value and validate
                mov    (32,r1),r0
                mov    (32,r2),r11
                add    r11,r0
                mov    (32,r3),r11
                add    r11,r0
                mov.l   r0,@(divu_hr132,r14)   ;/384
                mov     #1,r0                  ;p.f
                mov.l   @(divu_hr132,r14),r11
                shll2   r11
                add     r4,r11
                mov     @r11,r10
                mov     r10,(16,r12)           ;pT.pT
                bra     @ok
                mov     r12,@r11

@ignore:        mov     #0,r0

@ok:            mov.w   r0,(20,r12)

                dt      r6
                bf/s    @loop
                add     #24,r12

                mov.l @r15+,r14
                mov.l @r15+,r13
                mov.l @r15+,r12
                mov.l @r15+,r11
                mov.l @r15+,r10
                mov.l @r15+,r9
                mov.l @r15+,r8
                mov.l @r15+,r7
                mov.l @r15+,r6
                mov.l @r15+,r5
                mov.l @r15+,r4
                rts
                nop

;------------------------------------------------------------------------------------------
;               Render Emap object
;------------------------------------------------------------------------------------------
RenderEmap:     mov     pr,@-r15
                mov     r4,@-r15                ;pModel
                mov     r5,@-r15                ;pZ
                mov     r6,@-r15                ;mLoc_Cam

;rearrange Loc_Cam
                mov     =tempcam,r0
                mov     @(0,r6),r1
                mov     r1,(0,r0)
                mov     @(16,r6),r1
                mov     r1,(4,r0)
                mov     @(32,r6),r1
                mov     r1,(8,r0)
                mov     @(4,r6),r1
                mov     r1,(12,r0)
                mov     @(20,r6),r1
                mov     r1,(16,r6)
                mov     @(36,r6),r1
                mov     r1,(32,r0)

;clear doneuv table
                mov     =doneuv,r0              ;done uv table
                mov     (28,r4),r1              ;num of vertex
                shlr2   r1
                shlr2   r1
                shlr2   r1
                add     #1,r1                   ;number of 32's
                mov     r1,r2
                shll8   r2
                shlr2   r2
                add     r2,r0                   ;end of clear area

                mov     #0,r2
@clear:
                rept    15
                mov     r2,@-r0
                endr
                dt      r1
                bf/s    @clear
                mov     r2,@-r0

                mov     #64,r0
@loop1:         mov     @r5,r6
                tst     r6,r6
                bf      @process
@back:          dt      r0
                bf/s    @loop1
                sub     #4,r5

                mov     @r15+,r5
                mov     @r15+,r6
                mov     @r15+,r4
                mov     @r15+,pr
                rts
                nop

@process:       mov     r5,@-r15            ;store pZ
                mov     r0,@-r15            ;store loop count
                mov     r6,r5               ;new pT

@loop:          mov
                mov
                add
                add

@next1:         mov     @(4,r5),r6
                mov     =doneuv,r3
                add     r6,r3
                add     r6,r3
                mov.w   @r3,r0
                tst     r0,r0
                bf      @next2
                bsr     @procvect
                nop

@next2:         mov     @(8,r5),r6
                mov     =doneuv,r3
                add     r6,r3
                add     r6,r3
                mov.w   @r3,r0
                tst     r0,r0
                bf      @next3
                bsr     @procvect
                nop

@next3:

                mov     @(36,r4),r1
                mov     (0,r5),r4
                shll8   r4
                shlr2   r4
                add     r1,r4               ;p0

                mov     (8,r5)r6
                shll8   r6
                shlr2   r6
                add     r1,r6               ;p2

                mov     r5,@-r15
                mov     (4,r5),r5
                shll8   r5
                shlr2   r5
                add     r1,r5               ;p1

                bsr     triangles
                nop

                mov     @r15+,r5
                mov     (16,r5),r5          ;next link
                mov     (16,r15),r4         ;pModel
                tst     r5,r5
                bf      @loop

                mov     @r15+,r0            ;loop
                bra     @back
                mov     @r15+r5             ;pZ

;------------------------------------------------------------------------------------------
;               process vector
;------------------------------------------------------------------------------------------
@procvect:      mov     pr,@-r15
                mov     #1,r0
                mov.w   r0,@r3
                mov     r7,@-r15
                mov     r8,@-r15                ;used in sqrt
                mov     r9,@-r15                ;etc
                mov     r10@-r15                ;
                mov     r11@-r15                ;
                mov     r12@-r15                ;
                mov     r13@-r15                ;
                mov     r14@-r15                ;divide address

                mov     @(36,r4),r7
                shll8   r6
                shlr2   r6
                add     r6,r7

                mov     r7,r0
                add     #12,r0
                mov     =tempcam,r1
                clrmac
                mov     r7,r0
                add     #12,r0
                
                mac     @r0+,r1+
                mov     #-1,r14
                shll8   r14                     ;point at divide addresses
                mac     @r0+,@r1+
                mov     #16,r2
                shll8   r2                      ;4096
                mac     @r0+,@r1+
                add     #-12,r0
                mov.l   r2,@(divu_jr,r14)       ;dy
                sts     macl,r10
                clrmac
                mac     @r0+,r1+
                mov.l   r10,@(divu_hr132,r14)
                mac     @r0+,@r1+
                mov.l   @(divu_rsr,r14),r10
                mac     @r0+,@r1+
                add     #-12,r0
                sts     macl,r11
                clrmac
                mac     @r0+,@r1+
                mov.l   r11,@(divu_hr132,r14)
                mac     @r0+,@r1+
                add     #-12,r0
                sts     macl,r11
                clrmac
                mac     @r0+,@r1+
                mov.l   r11@(divu_hr132,r14)
                mac     @r0+,@r1+
                mov     =@verts,r12
                mov     r10,@(12,r12)
                sts     macl,r10
                mov.l   r10,@(divu_hr132,r14)
                mov     r11,@(16,r12)
                mov.l   @(divu_rsr,r14),r11
                mov     r11,@(20,r12)

                mov     (24,r7),r0             ;p.xT
                muls    r0,r0
                mov     (28,r7),r1             ;p.yT
                sts     macl,r19               ;x*x
                muls    r1,r1
                mov     (32,r7),r2             ;p.zT
                sts     macl,r11               ;y*y
                muls    r2,r2
                add     r11,r10
                sts     macl,r11               ;z*z

                bsr     @sqrt
                add     r11,r10

                tst     r10,r10
                bf      @nozero
                mov     #1,r10
@nozero:

;vVertToCam.(x,y,z)
                mov     #-16,r11
                shll8   r11                    ;-4096
                muls    r0,r11                 ;x*-4096
                mov.l   r10,@(divu_jr,r14)     ;divL
                sts     macl,r0
                muls    r1,r11
                mov.l   r0,@(divu_hr132,r14)
                sts     macl,r1
                muls    r2,r11
                mov.l   @(divu_rsr,r14),r0
                mov.l   r1,@(divu_hr132,r14)
                mov     =@verts,r12
                mov     r0,@(0,r12)
                mov.l   @(divu_rsr,r14),r2
                mov     r1,@(4,r12)
                mov     r2,@(8,r12)

;reflect vector
                clrmac
                mov     r12,r0
                add     #12,r0
                mac     @r0+,@r12+
                mac     @r0+,@r12+
                mac     @r0+,@r12+
                sub     #12,r12
                sts     macl,r0

                cmp/pz  r0
                bt      @ref1
                mov     @(0,r12),r1             ;vL.x
                neg     r1,r1
                mov     @(4,r12),r2             ;vL.x
                neg     r2,r2                       
                mov     @(8,r12),r3             ;vL.x
                neg     r3,r3
                bra     @end
                mov     #0,r0                   ;return 0

@ref1:          shll    r0                      ;*2

                mov     @(12,r12),r1
                shll8   r1
                dmuls   r0,r1
                mov     @(16,r12),r2
                shll8   r2
                sts     mach,r1
                dmuls   r0,r2
                mov     @(0,r12),r3
                sub     r3,r1
                mov     @(20,r12),r11
                shll8   r11
                sts     mach,r2
                dmuls   r0,r11
                mov     @(4,r12),r3
                sub     r3,r2
                sts     mach,r3
                mov     @(8,r12),r11
                sub     r11,r3
                mov     #1,r0
@end:
;act on reflect vector
                mov     r1,r10
                muls    r10,r10
                mov     r2,r11
                sts     macl,r10                ;x*x
                muls    r11,r11
                sts     macl,r11                ;y*y

                bsr     @sqrt
                add     r11,r10

                add     #1,r10

                mov     #16,r11
                shll8   r11                     ;4096
                muls    r1,r11                  ;x*4096
                mov.l   r10,@(divu_jr,r14)      ;divL
                sts     macl,r1
                muls    r2,r11                  ;y*4096
                mov.l   r1,@(divu_hr132,r14)
                sts     macl,r2
                mov.l   @(divu_rsr,r14),r1
                mov.l   r2,@(divu_hr132,r14)
                tst     r0,r0
                mov.l   @(divu_rsr,r14),r2
                bf      @part2

;part 1 of reflect bit
                mov     #2,r0
                shll8   r0                      ;512
                add     r11,r1                  ;x+4096
                shll8   r1
                shll2   r1                      ;*1024
                add     r0,r1                   ;+512
                add     r11,r2                  ;y+4096
                mov     r1,(48,r7)              ;p.u
                shll8   r2
                shll2   r2                      ;*1024
                add     r0,r2                   ;+512
                bra     @end2
                mov     r2,(52,r7)              ;p.u

;part 2 of reflect bit
@part2:         add     r11,r3                  ;z+4096
                add     r3,r3                   ;*2

                bsr     @sqrt
                mov     r3,r10

                add     r10,r10
                shll2   r10                     ;*8

                muls    r1,r10                  ;x*radius*8
                mov     #64,r0
                shll16  r0                      ;4194304
                sts     macl,r1
                muls    r2,r10                  ;y*radius*8
                add     r0,r1                   ;+4194304
                mov     r1,(48,r7)              ;p.u
                sts     macl,r2
                add     r0,r2
                mov     r2,(52,r7)              ;p.v

@end2:          mov.l   @r15+,r14
                mov.l   @r15+,r13
                mov.l   @r15+,r12
                mov.l   @r15+,r11
                mov.l   @r15+,r10
                mov.l   @r15+,r9
                mov.l   @r15+,r8
                mov.l   @r15+,r7
                mov     @r15+,pr
                rts
                nop

                .align  4
                littab

;send r10 as value to squareroot (returns r10)
;uses r11-r13
;r14 points at divide address
@sqrt:          mov     #0,r11
                mov     r11,r12
                mov     =@sqrttab,r14
                mov     @r14+,r13

                mov     =4096,r9

                cmp/hs  r13,r10
                bf/s    @case1
                mov     #12,r6
                or      r9,r11
                mov     r13,r12
@case1:
                muls    r11,r9
@sqrtloop:      mov     @r14+,r8
                shlr    r9
                sts     macl,r13
                add     r8,r13
                add     r12,r13
                cmp/hs  r13,r10
                bf/s    @case
                dt      r6
                or      r9
                mov     r13,r12

@case:          bf/s    @sqrtloop
                muls    r11,r9

                mov     #-1,r14
                shll8   r14                    ;point at divide addresses

                rts
                mov     r11,r10                ;result

                .align  4
@sqrttab:
o:              set     4096
                rept    13
                dc.l    o*o
o:              set     o/2
                endr

;@sqrt:         mov     #1,r11                 ;r11 = 1.0
;               shll16  r11
;               cmp/gt  r11,r10                ;x > 1.0 ??
;               bt      @00
;               bra     @01
;               mov     r11,r12                ;s = 1.0
;       @00:
;               mov     r10,r12                ;s = x
;       @01:    
;               mov     r12,r13                ;last = s
;               mov.l   r12,@(divu_jr,r14)     ;s = (x/s + s)/s
;               swap.w  r10,r11
;               exts.w  r11,r11
;               mov.l   r11,@(divu_hrh,r14)
;               mov     r10,r11
;               shll16  r11
;               mov.l   r11,@(divu_hrl,r14)
;               nop
;               mov.l   @(divu_rsr,r14),r11    ;r11 = x/s
;               add     r11,r12                ;r12 = (x/s + s)/2
;               shlr    r12                    ;       //
;               cmp/gt  r12,r13                ;s < last ??
;               bt      @01
;               rts
;               mov     r13,r10                ;sqrt(x) = last

@verts:         ds.l    6
tempcam:        ds.l    9
                littab

;------------------------------------------------------------------------------------------
;               reflect vector
;------------------------------------------------------------------------------------------
reflectvect:
                clrmac
                mov     r4,r0
                mov     r5,r1
                mac     @r0+,@r1+
                mac     @r0+,@r1+
                mac     @r0+,@r1+
                sts     macl,r0

                cmp/pz  r0
                bt      @ref1
                mov     @(0,r5),r0             ;vL.x
                neg     r0,r0
                mov     r0,@(0,r6)
                mov     @(4,r5),r0             ;vL.x
                neg     r0,r0
                mov     r0,@(4,r6)
                mov     @(8,r5),r0             ;vL.x
                neg     r0,r0
                mov     r0,@(4,r6)
                bra     @end
                mov     #0,r0                  ;return 0

@ref1:          shll    r0                     ;*2

                mov     @(0,r4),r1
                shll8   r1
                dmuls   r0,r1
                mov     @(4,r4),r2
                shll8   r2
                sts     mach,r1
                dmuls   r0,r2
                mov     @(0,r5),r3
                sub     r3,r1
                mov     r1,(0,r6)
                mov     @(8,r4),r2
                shll    r2
                sts     mach,r1
                dmuls   r0,r2
                mov     @(4,r5),r3
                sub     r3,r1
                mov     r1,(4,r6)
                sts     mach,r1
                mov     @(8,r5),r3
                sub     r3,r1
                mov     r1,(8,r6)
                mov     #1,r0

@end:
                rts
                nop

                .align  4
                littab

;------------------------------------------------------------------------------------------
;               Draw triangle code
;------------------------------------------------------------------------------------------
triangles:      mov     pr,@-r15
                mov     r4,@-r15               ;p0
                mov     r5,@-r15               ;p1
                mov     r6,@-r15               ;p2
                mov     r7,@-r15               
                mov     r8,@-r15               
                mov     r9,@-r15 
                mov     r10,@-r15
                mov     r11,@-r15
                mov     r12,@-r15
                mov     r13,@-r15
                mov     r14,@-r15

                mov     r4,r0

;sort vertex pointers
                mov     =(bytescreen),r4       ;pointer to screen

                mov     @(40,r0),r2            ;p0.yS
                mov     @(40,r5),r1            ;p1.ys
                cmp/gt  r1,r2
                bf      @sort1
                mov     r0,r2
                mov     r5,r0
                mov     r2,r5
@sort1:
                mov     @(40,r5),r2            ;p1.yS
                mov     @(40,r6),r1            ;p2.yS
                cmp/gt  r1,r2
                bf      @sort2
                mov     r5,r2
                mov     r6,r5
                mov     r2,r6
@sort2:
                mov     @(40,r5),r2            ;p1.yS
                mov     @(40,r6),r1            ;p2.yS
                cmp/gt  r1,r2
                bf      @sort2
                mov     r0,r2
                mov     r5,r0
                mov     r2,r5
@sort3:
                mov     @(40,r0),r8            ;p0.yS (screen Y)
                
                mov     #-1,r14
                shll8   r14                    ;point at divide addresses

;set long side 02?
                mov     @(40,r6),r10
                sub     r8,r10                 ;dy=p2.yS-y
                mov     @(36,r6),r9            ;p2.xS
                mov     @(36,r0),r2            ;p0.xS
                sub     r2,r9
                shll8   r9
                shll2   r9                     ;<<10

                mov.l   r10,@(divu_jr,r14)     ;dy
                mov.l   r9,@(divu_hr132,r14)   ;32 bit division

                mov     @(48,r6),r11           ;p2.u
                mov     @(48,r0),r2            ;p0.u
                sub     r2,r11
                mov.l   @(divu_rsr,r14),r9     ;dx=(p2.xs-p0.xs)/dy
                mov.l   r11,@(divu_hr132,r14)

                mov     @(52,r6),r12           ;p2.v
                mov     @(52,r0),r2            ;p0.v
                sub     r2,r12
                mov.l   @(divu_rsr,r14),r11    ;du=(p2.u-p0.u)/dy
                mov.l   r12,@(divu_hr132,r14)

                mov     @(36,r0),r7
                shll2   r7
                add     #2,r7                  ;2<<8=512
                shll8   r7                     ;x=(p0.xS<<10)+512
                mov.l   @(divu_rsr,r14),r12    ;dv=(p2.v-p0.v)/dy

                mov     @(48,r0),r2            ;u
                mov     @(52,r0),r3            ;v

                cmp/pz  r8
                bt      @ypos
                neg     r8,r1
                muls    r1,r9
                sts     macl,r13
                muls    r1,r11
                add     r13,r7                 ;x+=dx*-y
                sts     macl,r13
                muls    r1,r12
                add     r13,r2                 ;u+=du*-y
                sts     macl,r13
                bra     @yneg
                add     r13,r3                 ;v+=dv*-y

@ypos:          mov     =(screenw),r1
                muls    r1,r8
                sts     macl,r1
                add     r1,r4                  ;pscr+=y*swidth
@yneg:
;store regs
                mov     =(@x),r1
                mov     r12,@(20,r1)           ;dv
                mov     r11,@(16,r1)           ;du
                mov     r3,@(12,r1)            ;v
                mov     r2,@(8,r1)             ;u
                mov     r9,@(4,r1)             ;dx
                mov     r7,@r1                 ;x

;-----------------
;      TOP
;-----------------
                mov     @(40,r5),r1            ;p1.yS
                cmp/pz  r1                     ;p1.yS>=0?
                bf      @notop
                mov     @(40,r0),r2            ;p0.yS
                cmp/gt  r2,r1                  ;p1.yS>p0.yS?
                bf      @notop

;set short side 01?
                mov     @(40,r5),r10
                sub     r8,r10                  ;dy=p1.yS-y
                mov     @(36,r5),r9             ;p1.xS
                mov     @(36,r0),r2             ;p0.xS
                sub     r2,r9
                shll8   r9
                shll2   r9                      ;<<10

                mov.l   r10,@(divu_jr,r14)      ;dy
                mov.l   r9,@(divu_hr132,r14)    ;32 bit division

                mov     @(52,r5),r12            ;p1.v
                mov     @(52,r0),r2             ;p0.v
                sub     r2,r12
                mov.l   @(divu_rsr,r14),r11     ;du=(p1.u-p0.u)/dy
                mov.l   r12,@(divu_hr132,r14)
                
                mov     @(36,r0),r7
                shll2   r7
                add     #2,r7                   ;2<<8=512
                shll8   r7                      ;x=(p0.xS<<10)+512
                mov.l   @(divu_rsr,r14),r12     ;dv=(p1.v-p0.v)/dy

                mov     @(48,r0),r2             ;u
                mov     @(52,r0),r3             ;v

                cmp/pz  r8
                bt      @ypos2
                neg     r8,r1
                muls    r1,r9
                sts     macl,r8
                muls    r1,r11
                add     r8,r7                   ;x+=dx*-y
                sts     macl,r8
                muls    r1,r12
                add     r8,r2                   ;u+=du*-y
                sts     macl,r8
                add     r8,r3
                mov     #0,r8                   ;v+=dv*-y

@ypos2:
                mov     r0,@-r15                ;p0
                mov     r5,@-r15                ;p1
                mov     r6,@-r15                ;p2

                mov     @(40,r5),r1             ;p1.yS
                mov     r1,@-r15

                mov     =(@x),r1
                mov     @r1+,r0                 ;x
                mov     @r1+,r5                 ;dx
                mov     @r1+,r6                 ;u
                mov     @r1+,r10                ;v
                mov     @r1+,r13                ;du
                mov     @r1+,r14                ;dv

                mov     r5,@-r15

                bra     @topfirst
                nop

;scanline loop
@toploop:
                mov     r3,@-r15                ;v0
                mov     r0,@-r15                ;x
                mov     r6,@-r15                ;u
                mov     r7,@-r15                ;x0
                mov     r10,@-r15               ;v

                mov     r7,r1                   ;x0
                mov     r6,r7                   ;u

                bsr     scanline
                mov     r0,r6                   ;x

                mov     @r15+,r10
                mov     @r15+,r7
                mov     @r15+,r6
                mov     @r15+,r0
                mov     @r15+,r3
                mov     @r15+,r2
                mov     @r15+,r4

                mov     =(screenw),r1
                add     r1,r4                   ;pScr+=sWidth
                mov     @r15,r1
                add     r1,r0                   ;x+=dx
                add     r13,r6                  ;u+=du
                add     r14,r10                 ;v+=dv
                add     r9,r7                   ;x0+=dx0
                add     r11,r2                  ;u0+=du0
                add     r12,r3                  ;v0+=dv0
                add     #1,r8                   ;y++

@topfirst:      mov     @(4,r15),r1             ;p1.yS
                cmp/gt  r8,r1                   ;p1.yS>y?
                bf/s    @topend
                mov     r4,@-r15                ;pScr
                mov     =(screenh),r1
                cmp/gt  r8,r1                   ;sheight>y?
                bt/s    @toploop
                mov     r2,@-r15                ;u0
                add     #4,r15

@topend:        add     #4*3,r15                ;skip stacked p1.yS

                mov     =(@x),r1                ;store bits again
                mov     r0,@r1                  ;x
                mov     r6,@(8,r1)              ;u
                mov     r10,@(12,r1)            ;v

                mov     @r15+,r6                ;restore stacked p0-p2
                mov     @r15+r5
                mov     @r15+r0
@notop:         
                mov     =(screenh),r1
                cmp/eq  r1,r8
                bt      @end                    ;y=sheight

;-----------------
;     BOTTOM
;-----------------
                mov     @(40,r5),r13            ;p1.ys
                mov     @(40,r6),r2             ;p2.ys
                cmp/gt  r13,r2                  ;p2.yS>p1.yS?
                bf      @nobot

;set short side 12?
                mov     @(40,r6),r10
                mov     @(40,r5),r1
                sub     r1,r10                  ;dy=p2.yS-p1.yS
                mov     @(36,r6),r9             ;p2.xS
                mov     @(36,r5),r2             ;p1.xS
                sub     r2,r9
                shll8   r9
                shll2   r9                      ;<<10

                mov     #-1,r14
                shll8   r14                     ;point at divide addresses

                mov.l   r10,@(divu_jr,r14)      ;dy
                mov.l   r9,@(divu_hr132,r14)    ;32 bit division

                mov     @(48,r6),r11            ;p2.u
                mov     @(48,r5),r2             ;p1.u
                sub     r2,r11
                mov.l   @(divu_rsr,r14),r9      ;du=(p2.u-p1.u)/dy
                mov.l   r11,@(divu_hr132,r14)

                mov     @(36,r5),r7
                shll2   r7
                add     #2,r7                   ;2<<8=512

                /* Publically available code ends here :( */

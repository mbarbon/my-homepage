;
; Julia-morpher
; 
; R-boot / Syntax Error
;

.386
warn    icg
locals

single  equ     0       ; 0=raddoppia, 1=non raddoppia pixel
qtnum   equ     8192

toshift equ     10
startx  equ     -2080+stepx/2
starty  equ     1500-stepy/2
stepx   equ     13*(2-single)
stepy   equ     15
maxiter equ     47
maxd    equ     2564
;maxd    equ     6*1024+512

count   equ     300h
xd      equ     302h
yd      equ     304h
xc      equ     306h
yc      equ     308h
quadtbl equ     310h
paltbl  equ     quadtbl+4*qtnum

jm      segment byte public use16 'CODE'
        assume  cs:jm,ds:jm,ss:jm,es:jm
        org     100h
main    proc    near
        mov     di,count
        mov     cl,5
        rep stosw
        mov     al,013h
        int     10h
; precalcola tabella dei quadrati
        mov     cx,qtnum*2
        mov     bx,-qtnum
@@prcloop:
        mov     ax,bx
        imul    ax
        shrd    ax,dx,toshift
        stosw
        inc     bx
        loop    @@prcloop
; palette +18 bytez
        mov     dx,3c8h
        mov     al,1
        out     dx,al
        inc     dx

        push    di
        mov     ax,03f3fh
@@coloop:
        mov     ch,al
; primi 16
        stosw
        mov     [di],ah
; secondi 16
        mov     [di+16*3-2],cx
        mov     [di+16*3],ah
; terzi 16
        mov     [di+16*3*2-2],cl
        mov     [di+16*3*2-1],cx
; loopa
        inc     di
        sub     al,4
        jns     @@coloop
        
        pop     si
        mov     cx,48*3
        rep outsb
; init vari
        push    0a000h
        pop     fs
; loop principale
        mov     si,offset pathtable
@@whileloop:
        mov     di,count
        dec     word ptr [di]
        jns     short @@notreload
        cmp     si,offset pathend
        jne     short @@notend
        mov     si,offset pathloop
@@notend:
        mov     cl,3
@@inloop:
        lodsb
        cbw
        stosw
        loop    @@inloop
@@notreload:
        mov     ax,ds:[xd]
        add     ds:[xc],ax
        mov     ax,ds:[yd]
        add     ds:[yc],ax
; retrace
;        mov     dx,03dah
;@@vr1:
;        in      al,dx
;        test    al,8
;        jnz     @@vr1
;@@vr2:
;        in      al,dx
;        test    al,8
;        jz      @@vr2
; disegna Julia
        push    si
        xor     bp,bp
        mov     si,320*200-2
;
        mov     dx,100
        mov     bx,starty
@@loopy:
        mov     cx,320/(2-single)
        mov     di,startx
@@loopx:
        pusha
        mov     cx,maxiter
@@loopc:
        mov     ax,bx
        imul    di
        shr     ax,toshift-1        
        add     bx,bx
        shl     dx,16-(toshift-1)
        add     di,di
        or      ax,dx
        mov     dx,[quadtbl+bx+qtnum*2] 
        mov     bx,ax
        mov     ax,[quadtbl+di+qtnum*2]
        mov     di,ax
        add     ax,dx
        sub     di,dx
        cmp     ax,maxd
        ja      short @@endlc
        add     bx,ds:[yc]
        add     di,ds:[xc]
        dec     cx
        jnz     @@loopc
@@endlc:
        inc     cx
ife single
        mov     ch,cl
endif
ife single
        mov     fs:[bp],cx
        mov     fs:[si],cx
else
        mov     fs:[bp],cl
        mov     fs:[si],cl
endif
        popa
ife single
;        add     bp,2
;        sub     si,2
        inc     bp
        dec     si
        inc     bp
        dec     si
else
        inc     bp
        dec     si
endif
        add     di,stepx
        dec     cx
        jnz     @@loopx

        sub     bx,stepy
        dec     dx
        jnz     @@loopy

        pop     si
;       
        in      al,60h
        cmp     al,1
        jne     @@whileloop
; fine
        mov     ax,03h
        int     10h
        ret
main    endp

pathtable label
        db      32,16,16
        db      8,20,10
pathloop label
        db      40,-30,6
        db      40,-10,-20
        db      20,-21,-12
        db      60,25,-13
        db      60,5,15
        db      49,-2,20
        db      15,22,-19
        db      0,-1,8
pathend label

jm      ends

        end     main


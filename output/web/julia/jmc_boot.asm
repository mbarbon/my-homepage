;;; fixed point constants
fpdig   equ     11
fpmul   equ     2048

;;; Complex set boundaries/steps and Julia iterations
stepr   equ     30              ; 0.0146484375
;;; VGA 320x200 pixels were not square, so stepi should
;;; be stepr * 6 / 5 on real hardware
stepi   equ     30
startr  equ     -160 * stepr + stepr / 2
starti  equ     -100 * stepi + stepi / 2
endr    equ     160 * stepr + stepr / 2
maxm    equ     4 * fpmul
multbl_size equ 8 * fpmul
maxiter equ     191

minc    equ     512
maxc    equ     1700
startcr equ     999
startci equ     754
startdcr equ    -11
startdci equ    -7
offsetcr equ    512

        bits    16
        section .text
boot:
        ;; VGA 320 x 200
        mov     ax, 0x13
        int     0x10

        ;; setup data segment
        push    0x7c0
        pop     ds

        ;; segment for lookup table
        push    0x7000
        pop     es

        ;; set palette
        mov     dx, 0x3c8
        mov     al, 1
        out     dx, al
        inc     dx

        ;; temporarily set es = ds = 0x7000
        push    ds
        push    es
        pop     ds

        ;; ah fixed to 0x3f, al and ch decrease by 1
        xor     di, di
        mov     ax, 0x3f3f
palette:
        mov     ch, al
        ;; first 64 colors (xx 3f 3f)
        stosw
        mov     [di], ah
        ;; second 64 colors (00 xx 3f)
        mov     [di+64*3-2], cx
        mov     [di+64*3], ah
        ;; third 64 colors (00 00 xx)
        mov     [di+64*3*2-2], cl
        mov     [di+64*3*2-1], cx

        inc     di
        sub     al, 1
        jns     palette

        ;; set palette, then restore ds
        xor     si, si
        mov     cx, 192 * 3
        rep     outsb
        pop     ds

        ;; precompute squares
        xor     di, di
        mov     cx, 2*multbl_size
        mov     bx, -multbl_size
precompute:
        mov     ax, bx
        imul    bx
        shrd    ax, dx, fpdig
        stosw
        inc     bx
        loop    precompute

        ;; VGA memory
        push    0xa000
        pop     fs

move:
        ;; increment cr
        mov     bx, [cr]

        add     bx, [dcr]
        mov     [cr], bx
        ;; offset the real coordinate before checking if delta
        ;; needs to be flipped since it looks better that way
        add     bx, offsetcr
        jns     cr_pos
        neg     bx
cr_pos:

        ;; increment ci
        mov     ax, [ci]

        add     ax, [dci]
        mov     [ci], ax
        jns     ci_pos
        neg     ax
ci_pos:

        ;; check if dcr needs to be negated
        cmp     bx, maxc
        jae     neg_dcr
        cmp     bx, minc
        jae     cr_ok
        cmp     ax, minc
        jae     cr_ok
neg_dcr:
        neg     word[dcr]
cr_ok:

        ;; check if dci needs to be negated
        cmp     ax, maxc
        jae     neg_dci
        cmp     ax, minc
        jae     ci_ok
        cmp     bx, minc
        jae     ci_ok
neg_dci:
        neg     word[dci]
ci_ok:

        ;; pointers to start and end of screen to halve computations
        ;; by exploiting Julia simmetry
        xor     di, di
        mov     si, 320*200 - 1
        mov     bp, starti
loopy:
        mov     bx, startr
loopx:
        pusha
        mov     cx, maxiter
        ;; z = z * z + c
        ;; zr = zr * zr - zi * zi + cr
        ;; zy = 2 * zr * zi + ci
compute:
        ;; zr * zi
        mov     ax, bp
        imul    bx

        ;; double zr and zi for table lookup
        add     bp, bp
        add     bx, bx

        ;; shift one less, same as multiplying by two
        shrd    ax, dx, fpdig - 1

        ;; lookup squares
        mov     dx, [es:bp+2*multbl_size]
        mov     bx, [es:bx+2*multbl_size]

        ;; save new zi
        mov     bp, ax

        ;; ax = zr * zr - max_modulus
        lea     ax, [bx - maxm]

        ;; zr * zr - zi * zi
        sub     bx, dx

        ;; test ( zr * zr - max_modulus ) + zi * zi >= 0
        add     ax, dx
        jns     finish

        ;; add c
        add     bp, [ci]
        add     bx, [cr]

        dec cx
        jnz compute

finish:
        inc     cx
        mov     byte[fs:di], cl
        mov     byte[fs:si], cl

        popa

        inc     di
        dec     si

        add     bx, stepr
        cmp     bx, endr
        jl      loopx

        add     bp, stepi
        js      loopy

        in      al, 0x60
        cmp     al, 1
        jne     move

reboot:
        jmp     0xffff:0x0000

        section .data

        align   2
cr:     dw      startcr
ci:     dw      startci
dcr:    dw      startdcr
dci:    dw      startdci

txl equ 30h
txh equ 31h

org 0h
jmp main

org 03h
jmp timeOut

org 30h
main:
	mov sp, #100
	mov dptr, #tab
	;activation
	mov p0, #0
	mov p1, #0
	mov p2, #0
	mov p3, #00100000b
	;initialize value
	mov tl0, #low(0)
	mov th0, #high(0)
	;activation int
	mov tmod, #00001001b
	mov tcon, #00010001b
	mov ie, #81

loopMain:
	setb tr0
	jnb ie0, $
	clr tr0
	call timeOut
	call indic
	jmp loopMain

timeOut:
	mov txl, tl0
	mov txh, th0
	mov tl0, #low(0)
	mov th0, #high(0)
	clr ie0
	reti

indic:
	;подготовка чисел для вывода
	mov a, txh        ;первый байт
	anl a, #240       ;
	swap a            ;
	mov r0, a         ;
	mov a, txh        ;
	anl a, #15        ;
	mov r1, a         ;
        	
	mov a, txl        ;второй байт
	anl a, #240       ;
        swap a            ;
	mov r2, a         ;

	;индикация
	mov a, r2         ;вывод первого разряда
	movc a, @a+dptr   ;
	mov p0, a         ;
	mov a, r1         ;вывод второго разряда
	movc a, @a+dptr   ;
	add a, #80h       ;
	mov p1, a         ;
	mov a, r0         ;вывод третьего разряда
	movc a, @a+dptr   ;
	mov p2, a         ;
	ret

; Таблица кодов индикатора
tab: db 3fh, 06h, 5bh, 4fh, 66h, 6dh, 7dh, 07h, 7fh, 6fh, 77h, 7ch, 39h, 5eh, 79h, 71h, 80h
;        0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F    d
sjmp $
end



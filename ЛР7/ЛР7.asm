xl equ 30h
xh equ 31h
yl equ 32h
yh equ 33h
N1 equ 34h
N2 equ 35h
N0 equ 36h

org 0
jmp main
;���������� ������� TF0
org 0bh
jmp timeOut

org 30h
main:
	mov sp, #100
	;��������� ��������
	mov xl, #3
	mov xh, #0
	;��������� ���������
	mov p0, #0
	mov p1, #0
	mov p2, #0
	mov p3, #0cfh
	;��������� ����������
	mov tl0, #low(7628h)
	mov th0, #high(7628h)
	mov tmod, #01h
	mov ie, #82
;=================================
LoopMain:
    jnb tr0, skip
    jnb tf0, $
	clr tf0
	djnz r0, skip
	mov r0, N0
	call timeOut
	jmp LoopMain
;=================================
;�������� ���������
skip:
	mov 24h, tcon
 	jb p3.6, start
	jb p3.7, firstValue
 	mov a, p3
	anl a, #15
	add a, #0
	jnz ferrisWheel
	jmp LoopMain
;��������� ���������
firstValue:
	loopFV:
	jb p3.7, loopFV
	mov p0, #3
	mov p1, #0
	mov xl, #3
	mov xh, #0
	mov yl, #0
	mov yh, #0
        jmp loopMain

;��������� ���������  TF0
timeOut:
        mov tl0, #low(7628h)
	mov th0, #high(7628h)
	;�������
	mov a, xl
	mov b, #4
	mul ab
	mov yl, a
	mov xl, yl
	mov p0, yl

	mov a, b
	anl a, #3
	add a, #0
	jnz levelOne
	jmp count

	levelOne:        ;��������� ��������� ������ ��� �������� �� ������ ������� ����������� �� ������
	mov yh, b
	mov xh, yh
	mov p1, yh
	jmp endl

	count:
	mov a, xh
	mov b, #4
	mul ab
	mov yh, a
	mov xh, yh
	mov p1, yh
	endl:
	reti

;����/����
start:
	loopOut:
	jb p3.6, loopOut
	cpl tr0
	jmp loopMain

ferrisWheel:
        mov dptr, #tab      ;��� �������� �������� � r0 ��� ����� ������ ������ ��������� ����� �� ����������
	mov a, p3
	anl a, #15
	mov b, #5           ;�������� �� 5 ��� ��������������� ������������
	mul ab              ;
	mov N0, a           ;
	mov a, p3
	anl a, #15          ;������������ � ����� ���
	mov b, #10          ;��������� ����������� ����� � ��������� r3 � r2
	div ab              ;
	mov r3, a           ;������� ������
	jnz RazN1           ;
	mov N1, #0          ;
	jmp next1           ;
RazN1:  mov N1, #1          ;
next1:                      ;
	mov a, b            ;
	mov r2, a           ;������� ������
	jnz RazN2           ;
	mov N2, #0          ;
	jmp next2           ;
RazN2:	mov N2, #2          ;
next2:                      ;
	jmp indic           ;
        jmp loopMain        ;
        
indic:
	mov a, r3
	jz L1
 	sjmp L2
L2: 	setb p3.4
	sjmp L3
L1: 	clr p3.4
L3:
	setb p3.5
	mov a, r2
	movc a, @a+dptr
	mov p2, a
	ljmp LoopMain

stop:	jmp stop
tab: db 3fh, 06h, 5bh, 4fh, 66h, 6dh, 7dh, 07h, 7fh, 6fh, 80h
;        0    1    2    3    4    5    6    7    8    9    d
end

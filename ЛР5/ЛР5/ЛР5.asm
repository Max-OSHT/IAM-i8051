yl equ 30h
yh equ 31h
xl equ 32h
xh equ 33h

org 0
jmp main

org 30h
main:
mov SP, #100
mov yl, #low(27)     ;yl -> 1B
mov yh, #high(27)    ;yh -> 00
;������ ����� ������ �� ������ P3.6 � P3.7
;activation
mov p0, #0
mov p1, #0
mov p2, #0
mov p3, #0ffh
;central loop
;============
loop:
;�������
mov a, p3
anl a, #64
add a, #0
jz vvod
call form
jmp lo
vvod:
;���� X
mov a, p3
anl a, #128
add a, #0
jz wheel
call input
jmp lo
wheel:
mov a, xl
jz nl
jmp lo
nl:
mov a, p3
anl a, #63
add a, #0
jz lo
call ferrisWheel
jmp lo
lo: jmp loop
;============

;SubFunction
form:
loopForm:
jb p3.6, loopForm
clr c
mov a, #0             ;��������� �� ����
subb a, yl            ;
mov r3, a             ;
mov a, #0             ;
subb a, yh            ;
mov r4, a             ;

mov a, r3             ;�������� "�" � ������
anl a, xl             ;
mov yl, a             ;
		      ;
mov a, r4             ;
anl a, xh             ;
mov yh, a             ;

mov a, yl             ;���������� ���������� ��� �� ������������ ������
anl a, #240           ;
swap a                ;
mov r6, a             ;
mov a, yl             ;
anl a, #15            ;
mov r5, a             ;

mov p2, #63
mov p1, #63
mov p0, #63

loopView:
mov dptr, #tab
mov a, r5
movc a, @a+dptr
mov p2, a

mov a, r6
movc a, @a+dptr
mov p1, a

jb p3.6, loopView
ret

input:
loopInput:
jb p3.7, loopInput
;���������� �������� �����
mov a, xl
jnz null
mov xl, r2
jmp nil
null:
mov xl, #0
nil:
ret

ferrisWheel:
mov dptr, #tab
mov a, p3
clr acc.6
clr acc.7

loopTr16:             ;���� �������� � 16-���
mov b, #0ah
div ab
mov r1, a             ;������ ������
mov r0, b             ;������ ������
cjne r0, #0ah, d16
d16: jc write
jmp loopTr16

write:
swap a
orl a, r0
mov r2, a

mov a, r0             ;����� ������� ������� (�������)
movc a, @a+dptr       ;
mov p2, a             ;

mov a, r1             ;����� ������� ������� (�������)
movc a, @a+dptr       ;
mov p1, a             ;

mov a, #0             ;����� �������� ������� (�����)
movc a, @a+dptr       ;
mov p0, a             ;

exi:
ret
stop: jmp stop
tab: db 3fh, 06h, 5bh, 4fh, 66h, 6dh, 7dh, 07h, 7fh, 6fh, 77h, 7ch, 39h, 5eh, 79h, 71h
;        0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
end

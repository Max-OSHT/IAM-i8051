yl equ 30h
yh equ 31h
xl equ 32h
xh equ 33h

org 0
jmp main
;������� �������� ����������
org 03h
jmp form              ;���������� ������� INT0
org 13h
jmp input             ;���������� ������� INT1

org 30h
main:
mov yl, #low(179)      ;yl -> B3
mov yh, #high(179)     ;yh -> 00
mov sp,#120
;��������� ������
mov p0, #0
mov p1, #0
mov p2, #0
mov p3, #0ffh
;��������� ����������
mov tcon, #5
mov ie,#85h           ;���������� ����������
;=================================
loop:
mov a, xl
jz L1
jmp le
L1:
call ferrisWheel
le: jmp loop
;=================================


ferrisWheel:
mov dptr, #tab
mov a, p3
anl a, #243

loopTr16:             ;���� �������� � 16-���
mov b, #16
div ab
mov r1, a             ;������ ������
mov r0, b             ;������ ������
cjne r0, #16, d16
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
mov p0, #63           ;����� �������� ������� (�����)

ret

;���������� ���������� INT0
form:
loopForm:
jb p3.2, loopForm
clr c
mov a, #0             ;��������� �� ����
subb a, yl            ;
mov r3, a             ;
mov a, #0             ;
subb a, yh            ;
mov r4, a             ;

mov a, r3             ;�������� "�" � ������
anl a, xl             ;
mov yl, a             ;		      ;
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

loopView:
mov dptr, #tab
mov a, r5
movc a, @a+dptr
mov p2, a

mov a, r6
movc a, @a+dptr
mov p1, a

jb p3.2, loopView
reti                  ;���������� ��������� ����������

;���������� ���������� INT1
input:
loopInput:
jb p3.3, loopInput
;���������� �������� �����
mov a, xl
jnz null
mov xl, r2
jmp nil
null:
mov xl, #0
nil:
reti                  ;���������� ��������� ����������
; ������� ����� ����������
tab: db 3fh, 06h, 5bh, 4fh, 66h, 6dh, 7dh, 07h, 7fh, 6fh, 77h, 7ch, 39h, 5eh, 79h, 71h
;        0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
end


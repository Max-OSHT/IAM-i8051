;��������� ����� Y
Y equ 30h
H equ 31h


org 0
jmp main


org 30h
main:
mov Y, #1
mov P1, #0
mov P1, Y
;������ ���������� P3
;���������
clr P3.0
clr P3.1
setb P3.2
setb P3.3
setb P3.4
;=======================
loop:
;�������
mov A, P3
anl A, #4
add A, #0
jz vvod
call form
jmp le
vvod:
;����
mov A, P3
anl A, #8
add A, #0
jz zero
call input
jmp le
zero:
;�����
mov A, P3
anl A, #16
add A, #0
jz light1
call def
jmp le
light1:
;�������� P3
;���. ��� ��������
jnb PSW.6, light2
call light3
jmp le
light2:
clr P3.0
;��� �������� �
jc light4
jmp le
le: jmp loop
;�������� ����
;=======================

;������������
;��������� ������ P1
form:
loopForm:
jb P3.2, loopForm       ;������� ��� ������ �������� (����� ������ �������� ��� ����������)
mov A, Y
mov P1, A
mov B, #5
mul AB
cjne A, #255, check
check:
mov R0, B
cjne R0, #1, step       ;�������� ����� B ��� ����� ����
jmp bad
step:
jc good                 ;�������� ���� ��������
setb P3.1               ;���� ���� B �� ���������� ��� ��������
jmp bad
good:
mov P1, A
mov Y, #0
mov Y, A
jmp bad
bad:
ret
;������������ ������
def:
loopClear:
jb P3.4, loopClear      ;������� ��� ������ �������� (����� ������ �������� ��� ����������)
mov P1, #0
clr P3.0
clr P3.1
ret
;������������ ��������
light3:
setb P3.0
ret
light4:
setb P3.1
ret
;���� ������ P2
input:
mov P2, #255
mov B, #0
jmp loopInput
loopInput:
mov A, P2
jb P3.3, loopInput
mov H, A                ;��������� ��������� �����
mov P1, A
ret
stop: jmp stop
end


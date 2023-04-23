;����� ���������� Z
ZL equ 30h
ZH equ 31h
;����� ����������
rezL equ 36h
rezH equ 37h
;������ ���������
org 0h
jmp main
;������� �������� ����������
;�������� ���������
org 30h
main:
mov SP, #30 ;��������� ����������
mov ZL, #low(863)      ;035F - 2 byte
mov ZH, #high(863)
;������������� �����
mov rezL, ZL
mov rezH, ZH

;��������� �������
mov R0, #0             ;�������� � ������� ������
mov R1, #11            ;������� ������
mov DPTR, #ARR         ;������� �������� ������ ������� ������

;�������������� ����
circle:
clr C
mov A, R0              ;������� �������� � ������� ������
movc A, @A+DPTR        ;������ ����� �� ������ ��������
cjne A, #45, count     ;������� ������������� ����� ������
count: jc countiune
clr C
;mov XL, A
call func
countiune:
inc R0
djnz R1, circle
jmp stop
;������������
func:
push PSW
push ACC
clr RS0        ;������� �������� ����� ��� �2
setb RS1
;�������� �����
clr C
mov A, #0
subb A, rezL
mov R4, A      ;������������� ����� Z � low
mov A, #0
subb A, rezH
mov R5, A      ;������������� ����� Z � high
;������� "�" ��� ����� (�������������� ����� Z) � X
pop ACC
anl A, R4
mov rezL, A
mov A, #0
anL A, R5
mov rezH, A
;���������� ���������
pop PSW
ret ;����� �� ���������

stop: jmp stop ;������������
;������ ������
ARR: db 209, 78, 203, 251, 146, 225, 170, 91, 15, 92, 58, 55, 217, 39, 162, 23, 112, 8, 227, 200, 17, 116, 200, 64, 105
end

;������ ������������ �������������� �����
rezL equ 40h
rezH equ 41h
;������ ������������ ����������
varL equ 30h
varH equ 31h
;����� �������� ����������� ����������
varKL equ 32h
varKH equ 33h
;������ ���������
org 0h
jmp main
;������� �������� ����������
;�������� ���������
org 30h
main:
;������ ��������� �������� ����������
;��������� �����
mov varL, #low(2300)   ;08FC - 2 byte
mov varH, #high(2300)
;�������� ����������� ����������
mov varKL, #low(400)   ;FE70 - 2 byte  (0190)
mov varKH, #high(400)
;��������� �������
mov R0, #0             ;�������� � ������� ������
mov R1, #0
mov DPTR, #ARR         ;������� �������� ������ ������� ������
mov rezH, #0           ;��������� ����������
mov rezL, #0

;������� (��������) 400 � ��������� ������
mov A, varKL
add A, varL
mov varL, A
mov A, varKH
addc A, varH
mov varH, A
;������������� �����
mov rezL, varL
mov rezH, varH
;�������������� ����
circle:
clr C
mov A, R0              ;������� �������� � ������� ������
movc A, @A+DPTR        ;������ ����� �� ������ ��������
cjne A, #45, count     ;������� ������������� ����� ������
count: jc countiune
clr C
mov R1, A              ;���������� ��������� �����
mov A, rezL
subb A, R1
mov rezL, A
mov A, rezH
subb A, #0
mov rezH, A
jmp countiune
;��������� ��� ������ �� �����
countiune:
inc R0
mov A, rezH
anl A, #128
add A, #0
jz circle
stop: jmp stop         ;������������
;������ ������
ARR: db 209, 78, 203, 251, 146, 225, 170, 91, 15, 92, 58, 55, 217, 39, 162, 23, 112, 8, 227, 200, 17, 116, 200, 64, 105
end

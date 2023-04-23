;������ ������������ ������ ����������
val1L equ 16h	;������� ����
val1H equ 17h   ;������� ����

;������ ������������ ������ ����������
val2L equ 18h   ;������� ����
val2H equ 19h   ;������� ����

;������ ������������ ���������� ����������
rezML1    equ 20h ;������� ���� ������� ���� ����
rezMH1    equ 21h ;������� ���� ������� ���� ����
rezML2    equ 22h ;������� ���� ������� ���� ����
rezMH2    equ 23h ;������� ���� ������� ���� ����
rezMLH    equ 24h ;��������� �������� ������� ���� ����
rezMHH    equ 25h ;��������� �������� ������� ���� ����
rezML11   equ 26h ;������� ���� ������� ���� ����
rezMH11   equ 27h ;������� ���� ������� ���� ����
rezML21   equ 28h ;������� ���� ������� ���� ����
rezMH21   equ 29h ;������� ���� ������� ���� ����
rezMLL    equ 2Ah ;��������� �������� ������� ���� ����
rezMHL    equ 2Bh ;��������� �������� ������� ���� ����
rezML     equ 2Ch ;��������� ��������� ���� �����
rezMH     equ 2Dh ;��������� ��������� ���� �����
rezME     equ 2Eh ;��������� ��������� ���� �����
rezACT1   equ 1Ah ;��������� ��������� ������� ���� ����� X �� ����� Y
rezACT2   equ 1Bh ;��������� ��������� ������� ���� ����� X �� ����� Y
rezEND1   equ 08h ;������ ���� ��������� ����������
rezEND2   equ 09h ;������ ���� ��������� ����������
rezEND3   equ 0Ah ;������ ���� ��������� ����������
rezEND4   equ 0Bh ;����������� ����� ����������� ��������� - FF
rezEND5   equ 0Ch ;����������� ����� ����������� ��������� - FF
rezEND6   equ 0Dh ;����������� ����� ����������� ��������� - FF
rezEND7   equ 0Eh ;����������� ����� ����������� ��������� - FF
rezEND8   equ 0Fh ;����������� ����� ����������� ��������� - FF
rezA      equ 00h ;������ ������� ��������� ���������� ������ ����
rezB      equ 01h ;������ ������� ��������� ���������� ������ ����
rezC      equ 02h ;������ ������� ��������� ���������� ������ ����
;������ ���������
org 0
jmp main
org 30h
main:
;������ �������� ����������
mov val1L, #low(6943)  ;X = 1B1F - 2 �����
mov val1H, #high(6943)
mov val2L, #low(1063)  ;Y = 0427 - 2 �����
mov val2H, #high(1063)
;��������� ��� ������� �����:
;��������� ������� ����
mov A, val2H
mov B, val1H
mul AB
;���������� ����������
mov rezML1, A
mov rezMH1, B
;��������� ������� ����
mov A, val2L
mov B, val1H
mul AB
;���������� ����������
mov rezML2, A
mov rezMH2, B
;�������� ��� ������� ����
mov A, rezMH2
add A, rezML1
mov rezMHH, A
mov rezMLH, rezML2
;c������ ����� ������ ��������� � 24h(rezMLH) � 25h(rezMHH) ������
;��������� ��� ������� �����:
;��������� ������� ����
mov A, val2H
mov B, val1L
mul AB
;���������� ����������
mov rezML11, A
mov rezMH11, B
;��������� ������� ����
mov A, val2L
mov B, val1L
mul AB
;���������� ����������
mov rezML21, A
mov rezMH21, B
;�������� ��� ������� ����
mov A, rezMH21
add A, rezML11
mov rezMHL, A
mov rezMLL, rezML21
;������� ����� ������ ��������� � 2Ah(rezMLL) � 2Bh(rezMHL) ������
;������ ������� � ������� ����� ��� ��������� ������������ ���� �����
mov A, rezMHL
add A, rezMLH
mov rezMH, A
mov rezME, rezMHH
mov rezML, rezMLL
;��������� ��������� ���� ����� ��������� � 2Ch, 2Dh � 2Eh ������
;������ �� ����� X ����� Y
mov A, val1L
subb A, val2L
mov rezACT1, A
mov A, val1H
subb A, val2H
mov rezACT2, A
;��������� ������� ��������� ��������� � 1Ah(rezACT1) � 1Bh(rezACT2) ������
;������ �� ���������� ���� ���� ��������� ��������� ���� �����
mov A, rezACT1
subb A, rezML
mov rezEND1, A
mov A, rezACT2
subb A, rezMH
mov rezEND2, A
mov A, #0
subb A, rezME
mov rezEND3, A
;��������� 5 ���� ������ ���� ��������� FF ���������, �.�. �� �������� � �������
;�� ����������� -> ��������� ��������� � ������: 08h-0Fh
mov A, #0
subb A, #0
mov rezEND4, A
mov rezEND5, A
mov rezEND6, A
mov rezEND7, A
mov rezEND8, A
;!������ �������!, ��� ����� ��������� �� 3-��������� ����� ���������� �����
;������ ����������� � ���. ��� -> ��������� ���������� ������� (�����: 00h-07h)
mov A, rezML
subb A, rezACT1
cpl A
mov rezA, A
mov A, rezMH
subb A, rezACT2
cpl A
mov rezB, A
mov A, rezME
cpl A
mov rezC, A
;��������� 5 ���� ������ ���� ��������� FF
stop: jmp stop ;������������
end

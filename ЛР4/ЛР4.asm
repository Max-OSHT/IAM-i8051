;начальное число Y
Y equ 30h
H equ 31h


org 0
jmp main


org 30h
main:
mov Y, #1
mov P1, #0
mov P1, Y
;кнопки управления P3
;активация
clr P3.0
clr P3.1
setb P3.2
setb P3.3
setb P3.4
;=======================
loop:
;формула
mov A, P3
anl A, #4
add A, #0
jz vvod
call form
jmp le
vvod:
;ввод
mov A, P3
anl A, #8
add A, #0
jz zero
call input
jmp le
zero:
;сброс
mov A, P3
anl A, #16
add A, #0
jz light1
call def
jmp le
light1:
;лампочки P3
;доп. бит переноса
jnb PSW.6, light2
call light3
jmp le
light2:
clr P3.0
;бит переноса С
jc light4
jmp le
le: jmp loop
;ОСНОВНОЙ ЦИКЛ
;=======================

;ПОДПРОГРАММЫ
;индикатор данных P1
form:
loopForm:
jb P3.2, loopForm       ;команда для отлова задержки (чтобы кнопка работала при отпускании)
mov A, Y
mov P1, A
mov B, #5
mul AB
cjne A, #255, check
check:
mov R0, B
cjne R0, #1, step       ;проверка чтобы B был равен нулю
jmp bad
step:
jc good                 ;проверка бита переноса
setb P3.1               ;если есть B то загорается бит переноса
jmp bad
good:
mov P1, A
mov Y, #0
mov Y, A
jmp bad
bad:
ret
;подпрограмма сброса
def:
loopClear:
jb P3.4, loopClear      ;команда для отлова задержки (чтобы кнопка работала при отпускании)
mov P1, #0
clr P3.0
clr P3.1
ret
;подпрограмма лампочек
light3:
setb P3.0
ret
light4:
setb P3.1
ret
;ввод данных P2
input:
mov P2, #255
mov B, #0
jmp loopInput
loopInput:
mov A, P2
jb P3.3, loopInput
mov H, A                ;последнее введенное число
mov P1, A
ret
stop: jmp stop
end


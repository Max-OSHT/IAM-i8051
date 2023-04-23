;адрес переменной Z
ZL equ 30h
ZH equ 31h
;адрес результата
rezL equ 36h
rezH equ 37h
;начало программы
org 0h
jmp main
;область векторов прерываний
;основна€ программа
org 30h
main:
mov SP, #30 ;начальна€ переменна€
mov ZL, #low(863)      ;035F - 2 byte
mov ZH, #high(863)
;переписывание числа
mov rezL, ZL
mov rezH, ZH

;начальные услови€
mov R0, #0             ;смещение в массиве данных
mov R1, #11            ;счетчик циклов
mov DPTR, #ARR         ;задание базового адреса таблицы данных

;вычислительный цикл
circle:
clr C
mov A, R0              ;задание смещени€ в таблице данных
movc A, @A+DPTR        ;чтение байта из пам€ти программ
cjne A, #45, count     ;условие использовани€ байта данных
count: jc countiune
clr C
;mov XL, A
call func
countiune:
inc R0
djnz R1, circle
jmp stop
;подпрограмма
func:
push PSW
push ACC
clr RS0        ;задание рабочего банка –ќЌ є2
setb RS1
;основна€ прога
clr C
mov A, #0
subb A, rezL
mov R4, A      ;отрицательное число Z в low
mov A, #0
subb A, rezH
mov R5, A      ;отрицательное число Z в high
;команда "»" дл€ числа (отрицательного числа Z) и X
pop ACC
anl A, R4
mov rezL, A
mov A, #0
anL A, R5
mov rezH, A
;завершение программы
pop PSW
ret ;выход из программы

stop: jmp stop ;зацикливание
;массив данных
ARR: db 209, 78, 203, 251, 146, 225, 170, 91, 15, 92, 58, 55, 217, 39, 162, 23, 112, 8, 227, 200, 17, 116, 200, 64, 105
end

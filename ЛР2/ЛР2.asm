;адреса расположения промежуточного числа
rezL equ 40h
rezH equ 41h
;адреса расположения переменной
varL equ 30h
varH equ 31h
;адрес критерия прекращения вычислений
varKL equ 32h
varKH equ 33h
;начало программы
org 0h
jmp main
;область векторов прерываний
;основная программа
org 30h
main:
;задаем начальные значения переменных
;начальное число
mov varL, #low(2300)   ;08FC - 2 byte
mov varH, #high(2300)
;критерий прекращения вычислений
mov varKL, #low(400)   ;FE70 - 2 byte  (0190)
mov varKH, #high(400)
;начальные условия
mov R0, #0             ;смещение в массиве данных
mov R1, #0
mov DPTR, #ARR         ;задание базового адреса таблицы данных
mov rezH, #0           ;обнуление результата
mov rezL, #0

;перенос (сложение) 400 с начальным числом
mov A, varKL
add A, varL
mov varL, A
mov A, varKH
addc A, varH
mov varH, A
;переписывание числа
mov rezL, varL
mov rezH, varH
;вычислительный цикл
circle:
clr C
mov A, R0              ;задание смещения в таблице данных
movc A, @A+DPTR        ;чтение байта из памяти программ
cjne A, #45, count     ;условие использования байта данных
count: jc countiune
clr C
mov R1, A              ;уменьшение заданного числа
mov A, rezL
subb A, R1
mov rezL, A
mov A, rezH
subb A, #0
mov rezH, A
jmp countiune
;сравнение для выхода из цикла
countiune:
inc R0
mov A, rezH
anl A, #128
add A, #0
jz circle
stop: jmp stop         ;зацикливание
;массив данных
ARR: db 209, 78, 203, 251, 146, 225, 170, 91, 15, 92, 58, 55, 217, 39, 162, 23, 112, 8, 227, 200, 17, 116, 200, 64, 105
end

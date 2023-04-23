;адреса расположения первой переменной
val1L equ 16h	;младший байт
val1H equ 17h   ;старший байт

;адреса расположения второй переменной
val2L equ 18h   ;младший байт
val2H equ 19h   ;старший байт

;адреса расположения результата вычислений
rezML1    equ 20h ;младший байт старших двух байт
rezMH1    equ 21h ;старший байт старших двух байт
rezML2    equ 22h ;младший байт младших двух байт
rezMH2    equ 23h ;старший байт младших двух байт
rezMLH    equ 24h ;результат сложения младших двух байт
rezMHH    equ 25h ;результат сложения старших двух байт
rezML11   equ 26h ;младший байт старших двух байт
rezMH11   equ 27h ;старший байт старших двух байт
rezML21   equ 28h ;младший байт младших двух байт
rezMH21   equ 29h ;старший байт младших двух байт
rezMLL    equ 2Ah ;результат сложения младших двух байт
rezMHL    equ 2Bh ;результат сложения старших двух байт
rezML     equ 2Ch ;результат умножения двух чисел
rezMH     equ 2Dh ;результат умножения двух чисел
rezME     equ 2Eh ;результат умножения двух чисел
rezACT1   equ 1Ah ;результат вычитания младших байт числа X из числа Y
rezACT2   equ 1Bh ;результат вычитания старших байт числа X из числа Y
rezEND1   equ 08h ;первый байт итогового результата
rezEND2   equ 09h ;второй байт итогового результата
rezEND3   equ 0Ah ;третий байт итогового результата
rezEND4   equ 0Bh ;заполенение байта результатом вычитания - FF
rezEND5   equ 0Ch ;заполенение байта результатом вычитания - FF
rezEND6   equ 0Dh ;заполенение байта результатом вычитания - FF
rezEND7   equ 0Eh ;заполенение байта результатом вычитания - FF
rezEND8   equ 0Fh ;заполенение байта результатом вычитания - FF
rezA      equ 00h ;второй вариант итогового результата первый байт
rezB      equ 01h ;второй вариант итогового результата второй байт
rezC      equ 02h ;второй вариант итогового результата третий байт
;начало программы
org 0
jmp main
org 30h
main:
;задаем значения переменных
mov val1L, #low(6943)  ;X = 1B1F - 2 байта
mov val1H, #high(6943)
mov val2L, #low(1063)  ;Y = 0427 - 2 байта
mov val2H, #high(1063)
;умножение для старшей части:
;умножение старших байт
mov A, val2H
mov B, val1H
mul AB
;сохранение результата
mov rezML1, A
mov rezMH1, B
;умножение младших байт
mov A, val2L
mov B, val1H
mul AB
;сохранение результата
mov rezML2, A
mov rezMH2, B
;сложение для страших байт
mov A, rezMH2
add A, rezML1
mov rezMHH, A
mov rezMLH, rezML2
;cтаршая часть теперь находится в 24h(rezMLH) и 25h(rezMHH) байтах
;умножение для младшей части:
;умножение старших байт
mov A, val2H
mov B, val1L
mul AB
;сохранение результата
mov rezML11, A
mov rezMH11, B
;умножение младших байт
mov A, val2L
mov B, val1L
mul AB
;сохранение результата
mov rezML21, A
mov rezMH21, B
;сложение для младших байт
mov A, rezMH21
add A, rezML11
mov rezMHL, A
mov rezMLL, rezML21
;младшая часть теперь находится в 2Ah(rezMLL) и 2Bh(rezMHL) байтах
;сложим младшую и старшую части для получения произведения двух чисел
mov A, rezMHL
add A, rezMLH
mov rezMH, A
mov rezME, rezMHH
mov rezML, rezMLL
;результат умножения двух чисел находится в 2Ch, 2Dh и 2Eh байтах
;вычтем из числа X число Y
mov A, val1L
subb A, val2L
mov rezACT1, A
mov A, val1H
subb A, val2H
mov rezACT2, A
;результат первого вычитания находится в 1Ah(rezACT1) и 1Bh(rezACT2) байтах
;вычтем из полученных выше байт результат умножения двух чисел
mov A, rezACT1
subb A, rezML
mov rezEND1, A
mov A, rezACT2
subb A, rezMH
mov rezEND2, A
mov A, #0
subb A, rezME
mov rezEND3, A
;остальные 5 байт должны быть заполнены FF саморучно, т.к. мы работаем с байтами
;по отдельности -> результат находится в байтах: 08h-0Fh
mov A, #0
subb A, #0
mov rezEND4, A
mov rezEND5, A
mov rezEND6, A
mov rezEND7, A
mov rezEND8, A
;!второй вариант!, где после вычитания из 3-байтового числа полученное число
;просто переводится в доп. код -> результат аналогичен первому (байты: 00h-07h)
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
;остальные 5 байт должны быть заполнены FF
stop: jmp stop ;зацикливание
end

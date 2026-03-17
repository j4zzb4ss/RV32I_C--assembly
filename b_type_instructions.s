b_type_operations:
        # ПРОЛОГ ФУНКЦИИ - подготовка стекового кадра
        addi    sp,sp,-48        # Выделяем 48 байт в стеке
        sw      s0,44(sp)        # Сохраняем старый frame pointer
        addi    s0,sp,48         # Устанавливаем новый frame pointer
        sw      a0,-36(s0)        # Сохраняем параметр a в стек [s0-36]
        sw      a1,-40(s0)        # Сохраняем параметр b в стек [s0-40]
        sw      zero,-20(s0)      # result = 0 [s0-20]

        # ОПЕРАЦИЯ 1: BNE - переход, если не равно
        # C код: if (a != b) result += 200? 
        # Здесь сначала проверяется a == b для пропуска
        lw      a4,-36(s0)        # a4 = a
        lw      a5,-40(s0)        # a5 = b
        bne     a4,a5,.L2         # if (a != b) пропускаем следующую операцию (переход к .L2)
        # Этот код выполняется ТОЛЬКО если a == b
        lw      a5,-20(s0)        # a5 = result
        addi    a5,a5,100         # a5 = result + 100
        sw      a5,-20(s0)        # result = result + 100
.L2:

        # ОПЕРАЦИЯ 2: BEQ - переход, если равно
        # C код: if (a == b) пропускаем? Здесь наоборот
        lw      a4,-36(s0)        # a4 = a
        lw      a5,-40(s0)        # a5 = b
        beq     a4,a5,.L3         # if (a == b) пропускаем инкремент на 200
        # Этот код выполняется ТОЛЬКО если a != b
        lw      a5,-20(s0)        # a5 = result
        addi    a5,a5,200         # a5 = result + 200
        sw      a5,-20(s0)        # result = result + 200
.L3:

        # ОПЕРАЦИЯ 3: BGE - переход, если больше или равно (signed)
        # C код: if (a >= b) пропускаем? Здесь if (a < b) result += 300
        lw      a4,-36(s0)        # a4 = a
        lw      a5,-40(s0)        # a5 = b
        bge     a4,a5,.L4         # if (a >= b) пропускаем инкремент
        # Этот код выполняется ТОЛЬКО если a < b
        lw      a5,-20(s0)        # a5 = result
        addi    a5,a5,300         # a5 = result + 300
        sw      a5,-20(s0)        # result = result + 300
.L4:

        # ОПЕРАЦИЯ 4: BLT - переход, если меньше (signed)
        # C код: if (a < b) пропускаем? Здесь if (a >= b) result += 400
        lw      a4,-36(s0)        # a4 = a
        lw      a5,-40(s0)        # a5 = b
        blt     a4,a5,.L5         # if (a < b) пропускаем инкремент
        # Этот код выполняется ТОЛЬКО если a >= b
        lw      a5,-20(s0)        # a5 = result
        addi    a5,a5,400         # a5 = result + 400
        sw      a5,-20(s0)        # result = result + 400
.L5:

        # Подготовка для беззнаковых сравнений
        lw      a5,-36(s0)        # a5 = a
        sw      a5,-28(s0)        # сохраняем как unsigned ua [s0-28]
        lw      a5,-40(s0)        # a5 = b
        sw      a5,-32(s0)        # сохраняем как unsigned ub [s0-32]

        # ОПЕРАЦИЯ 5: BGEU - переход, если больше или равно (unsigned)
        # C код: if (ua >= ub) пропускаем? Здесь if (ua < ub) result += 500
        lw      a4,-28(s0)        # a4 = ua
        lw      a5,-32(s0)        # a5 = ub
        bgeu    a4,a5,.L6         # if (ua >= ub) пропускаем инкремент
        # Этот код выполняется ТОЛЬКО если ua < ub
        lw      a5,-20(s0)        # a5 = result
        addi    a5,a5,500         # a5 = result + 500
        sw      a5,-20(s0)        # result = result + 500
.L6:

        # ОПЕРАЦИЯ 6: BLTU - переход, если меньше (unsigned)
        # C код: if (ua < ub) пропускаем? Здесь if (ua >= ub) result += 600
        lw      a4,-28(s0)        # a4 = ua
        lw      a5,-32(s0)        # a5 = ub
        bltu    a4,a5,.L7         # if (ua < ub) пропускаем инкремент
        # Этот код выполняется ТОЛЬКО если ua >= ub
        lw      a5,-20(s0)        # a5 = result
        addi    a5,a5,600         # a5 = result + 600
        sw      a5,-20(s0)        # result = result + 600
.L7:

        # ЦИКЛ: for (int i = 0; i < a; i++) result += i
        sw      zero,-24(s0)      # i = 0 [s0-24]
        j       .L8               # переход к проверке условия цикла

.L9:                              # ТЕЛО ЦИКЛА
        lw      a4,-20(s0)        # a4 = result
        lw      a5,-24(s0)        # a5 = i
        add     a5,a4,a5          # a5 = result + i
        sw      a5,-20(s0)        # result = result + i
        lw      a5,-24(s0)        # a5 = i
        addi    a5,a5,1           # a5 = i + 1
        sw      a5,-24(s0)        # i = i + 1

.L8:                              # ПРОВЕРКА УСЛОВИЯ ЦИКЛА
        lw      a4,-24(s0)        # a4 = i
        lw      a5,-36(s0)        # a5 = a
        blt     a4,a5,.L9         # if (i < a) переход к телу цикла (BLT)

        # ЭПИЛОГ ФУНКЦИИ
        lw      a5,-20(s0)        # a5 = result
        mv      a0,a5             # a0 = result (возвращаемое значение)
        lw      s0,44(sp)         # восстанавливаем старый frame pointer
        addi    sp,sp,48          # освобождаем стек
        jr      ra                # возвращаемся

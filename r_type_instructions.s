r_type_operations:
        # ПРОЛОГ ФУНКЦИИ
        addi    sp,sp,-48          # Выделяем 48 байт в стеке
        sw      s0,44(sp)          # Сохраняем старый frame pointer
        addi    s0,sp,48           # Устанавливаем новый frame pointer
        sw      a0,-36(s0)         # Сохраняем параметр a (первый аргумент) в стек
        sw      a1,-40(s0)         # Сохраняем параметр b (второй аргумент) в стек
        sw      zero,-20(s0)       # result = 0 (инициализация локальной переменной)

        # ОПЕРАЦИЯ: result += a + b (сложение)
        lw      a4,-36(s0)         # a4 = a (загружаем из стека)
        lw      a5,-40(s0)         # a5 = b (загружаем из стека)
        add     a5,a4,a5           # a5 = a + b
        lw      a4,-20(s0)         # a4 = result (текущее значение)
        add     a5,a4,a5           # a5 = result + (a + b)
        sw      a5,-20(s0)         # сохраняем новый result

        # ОПЕРАЦИЯ: result += a - b (вычитание)
        lw      a4,-36(s0)         # a4 = a
        lw      a5,-40(s0)         # a5 = b
        sub     a5,a4,a5           # a5 = a - b
        lw      a4,-20(s0)         # a4 = result
        add     a5,a4,a5           # a5 = result + (a - b)
        sw      a5,-20(s0)         # сохраняем result

        # ОПЕРАЦИЯ: result += a & b (AND - побитовое И)
        lw      a4,-36(s0)         # a4 = a
        lw      a5,-40(s0)         # a5 = b
        and     a5,a4,a5           # a5 = a & b
        lw      a4,-20(s0)         # a4 = result
        add     a5,a4,a5           # a5 = result + (a & b)
        sw      a5,-20(s0)         # сохраняем result

        # ОПЕРАЦИЯ: result += a | b (OR - побитовое ИЛИ)
        lw      a4,-36(s0)         # a4 = a
        lw      a5,-40(s0)         # a5 = b
        or      a5,a4,a5           # a5 = a | b
        lw      a4,-20(s0)         # a4 = result
        add     a5,a4,a5           # a5 = result + (a | b)
        sw      a5,-20(s0)         # сохраняем result

        # ОПЕРАЦИЯ: result += a ^ b (XOR - исключающее ИЛИ)
        lw      a4,-36(s0)         # a4 = a
        lw      a5,-40(s0)         # a5 = b
        xor     a5,a4,a5           # a5 = a ^ b
        lw      a4,-20(s0)         # a4 = result
        add     a5,a4,a5           # a5 = result + (a ^ b)
        sw      a5,-20(s0)         # сохраняем result

        # ОПЕРАЦИЯ: result += a << (b & 31) (SLL - логический сдвиг влево)
        lw      a5,-40(s0)         # a5 = b
        andi    a5,a5,31           # a5 = b & 31 (маскируем, т.к. сдвиг только на 0-31)
        lw      a4,-36(s0)         # a4 = a
        sll     a5,a4,a5           # a5 = a << (b & 31)
        lw      a4,-20(s0)         # a4 = result
        add     a5,a4,a5           # a5 = result + (a << ...)
        sw      a5,-20(s0)         # сохраняем result

        # ОПЕРАЦИЯ: result += a >> (b & 31) (SRA - арифметический сдвиг вправо)
        lw      a5,-40(s0)         # a5 = b
        andi    a5,a5,31           # a5 = b & 31 (маскируем)
        lw      a4,-36(s0)         # a4 = a
        sra     a5,a4,a5           # a5 = a >> (b & 31) (с сохранением знака)
        lw      a4,-20(s0)         # a4 = result
        add     a5,a4,a5           # a5 = result + (a >> ...)
        sw      a5,-20(s0)         # сохраняем result

        # ОПЕРАЦИЯ: if (a < b) result += 1 (SLT - установка меньше)
        lw      a4,-36(s0)         # a4 = a
        lw      a5,-40(s0)         # a5 = b
        bge     a4,a5,.L2          # if (a >= b) пропускаем инкремент
        lw      a5,-20(s0)         # a5 = result
        addi    a5,a5,1            # a5 = result + 1
        sw      a5,-20(s0)         # сохраняем result
.L2:

        # ОПЕРАЦИЯ: if ((unsigned)a < (unsigned)b) result += 1 (SLTU - беззнаковое сравнение)
        lw      a4,-36(s0)         # a4 = a (как беззнаковое)
        lw      a5,-40(s0)         # a5 = b (как беззнаковое)
        bgeu    a4,a5,.L3          # if (a >= b) беззнаково пропускаем
        lw      a5,-20(s0)         # a5 = result
        addi    a5,a5,1            # a5 = result + 1
        sw      a5,-20(s0)         # сохраняем result
.L3:

        # ЭПИЛОГ ФУНКЦИИ - подготовка к возврату
        lw      a5,-20(s0)          # a5 = финальное значение result
        mv      a0,a5               # a0 = a5 (готовим возвращаемое значение)
        lw      s0,44(sp)           # восстанавливаем старый frame pointer
        addi    sp,sp,48            # освобождаем стек
        jr      ra                  # возвращаемся в вызывающую функцию

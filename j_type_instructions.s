# ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ: helper_function
# Вызывается из j_type_examples для демонстрации J-type инструкций

helper_function:
        # ПРОЛОГ вспомогательной функции
        addi    sp,sp,-32        # Выделяем 32 байта в стеке
        sw      s0,28(sp)        # Сохраняем frame pointer
        addi    s0,sp,32         # Устанавливаем новый frame pointer
        sw      a0,-20(s0)        # Сохраняем параметр x в стек [s0-20]

        # ТЕЛО ФУНКЦИИ: return x * 2
        lw      a5,-20(s0)        # a5 = x
        slli    a5,a5,1           # a5 = x * 2 (сдвиг влево на 1 = умножение на 2)
        mv      a0,a5             # a0 = a5 (готовим возвращаемое значение)

        # ЭПИЛОГ вспомогательной функции
        lw      s0,28(sp)         # Восстанавливаем frame pointer
        addi    sp,sp,32          # Освобождаем стек
        jr      ra                # J-type: возврат в вызывающую функцию (jalr x0, ra, 0)


# ОСНОВНАЯ ФУНКЦИЯ: j_type_examples
# Демонстрация J-type инструкций (JAL и JALR)

j_type_examples:
        # ПРОЛОГ основной функции
        addi    sp,sp,-48        # Выделяем 48 байт в стеке
        sw      ra,44(sp)        # Сохраняем обратный адрес (return address)
        sw      s0,40(sp)        # Сохраняем старый frame pointer
        addi    s0,sp,48         # Устанавливаем новый frame pointer
        sw      a0,-36(s0)        # Сохраняем параметр a в стек [s0-36]
        sw      zero,-20(s0)      # result = 0 [s0-20]

        # ОПЕРАЦИЯ 1: JAL - прямой вызов функции
        # C код: result = helper_function(a);
        lw      a0,-36(s0)        # a0 = a (готовим первый аргумент)
        call    helper_function    # J-type: jal ra, helper_function
                                   # call - псевдоинструкция для jal
        sw      a0,-20(s0)        # сохраняем результат в result [s0-20]

        # Подготовка к косвенному вызову
        # C код: int (*func_ptr)(int) = &helper_function;
        lui     a5,%hi(helper_function)  # a5 = старшие 20 бит адреса helper_function
        addi    a5,a5,%lo(helper_function) # a5 = полный адрес helper_function
        sw      a5,-24(s0)        # сохраняем func_ptr в стек [s0-24]

        # ОПЕРАЦИЯ 2: JALR - косвенный вызов через указатель
        # C код: result += func_ptr(a * 2);
        lw      a5,-36(s0)        # a5 = a
        slli    a5,a5,1           # a5 = a * 2
        lw      a4,-24(s0)        # a4 = func_ptr (адрес helper_function)
        mv      a0,a5             # a0 = a * 2 (аргумент для функции)
        jalr    a4                # J-type: jalr ra, a4, 0
                                   # Переход по адресу в a4, ra сохраняется автоматически
        mv      a4,a0             # a4 = результат вызова
        lw      a5,-20(s0)        # a5 = result
        add     a5,a5,a4          # a5 = result + результат вызова
        sw      a5,-20(s0)        # сохраняем новый result

        # ЭПИЛОГ основной функции
        lw      a5,-20(s0)        # a5 = result
        mv      a0,a5             # a0 = result (возвращаемое значение)
        lw      ra,44(sp)         # восстанавливаем обратный адрес
        lw      s0,40(sp)         # восстанавливаем frame pointer
        addi    sp,sp,48          # освобождаем стек
        jr      ra                # J-type: возврат из функции (jalr x0, ra, 0)

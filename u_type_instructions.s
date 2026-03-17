u_type_operations:
        # ПРОЛОГ ФУНКЦИИ
        addi    sp,sp,-32        # Выделяем 32 байта в стеке
        sw      s0,28(sp)        # Сохраняем старый frame pointer
        addi    s0,sp,32         # Устанавливаем новый frame pointer
        sw      zero,-20(s0)      # result = 0 [s0-20]

        # ОПЕРАЦИЯ 1: LUI для числа, кратного 0x1000
        # C код: int big_number = 0x12345000;
        li      a5,305418240      # a5 = 0x12345000 (305418240 в десятичной)
                                  # li - псевдоинструкция, превратится в LUI
        sw      a5,-24(s0)        # сохраняем big_number в стек [s0-24]

        # result += big_number
        lw      a4,-20(s0)        # a4 = result
        lw      a5,-24(s0)        # a5 = big_number
        add     a5,a4,a5          # a5 = result + big_number
        sw      a5,-20(s0)        # result = result + big_number

        # ОПЕРАЦИЯ 2: LUI + ADDI для числа, не кратного 0x1000
        # C код: int very_big = 0x12345FFF;
        li      a5,305422336      # a5 = 0x12345000 (LUI для верхних 20 бит)
        addi    a5,a5,-1          # a5 = 0x12345000 - 1 = 0x12344FFF? 
                                  # Но в коде написано -1, хотя должно быть +0xFFF
                                  # Возможно, опечатка в дизассемблере
        sw      a5,-28(s0)        # сохраняем very_big в стек [s0-28]

        # result += very_big
        lw      a4,-20(s0)        # a4 = result
        lw      a5,-28(s0)        # a5 = very_big
        add     a5,a4,a5          # a5 = result + very_big
        sw      a5,-20(s0)        # result = result + very_big

        # ОПЕРАЦИЯ 3: LUI + LW для доступа к статической переменной
        # C код: result += static_var;
        lui     a5,%hi(static_var.1520)   # a5 = старшие 20 бит адреса static_var
        lw      a5,%lo(static_var.1520)(a5) # a5 = память[a5 + младшие 12 бит] = static_var
        lw      a4,-20(s0)        # a4 = result
        add     a5,a4,a5          # a5 = result + static_var
        sw      a5,-20(s0)        # result = result + static_var

        # ОПЕРАЦИЯ 4: LUI + LW для доступа к глобальной переменной
        # C код: result += global_var;
        lui     a5,%hi(global_var) # a5 = старшие 20 бит адреса global_var
        lw      a5,%lo(global_var)(a5) # a5 = память[a5 + младшие 12 бит] = global_var
        lw      a4,-20(s0)        # a4 = result
        add     a5,a4,a5          # a5 = result + global_var
        sw      a5,-20(s0)        # result = result + global_var

        # ЭПИЛОГ ФУНКЦИИ
        lw      a5,-20(s0)        # a5 = result
        mv      a0,a5             # a0 = result (возвращаемое значение)
        lw      s0,28(sp)         # восстанавливаем старый frame pointer
        addi    sp,sp,32          # освобождаем стек
        jr      ra                # возвращаемся

# СЕКЦИЯ ДАННЫХ - глобальные и статические переменные
global_var:
        .word   100                # глобальная переменная со значением 100

static_var.1520:
        .word   42                 # статическая переменная со значением 42
                                   # .1520 - суффикс для уникальности имени

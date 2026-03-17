int u_type_operations(void) {
    int result = 0;
    
    // LUI - Load Upper Immediate
    // Загружает 20 старших бит в регистр
    int big_number = 0x12345000;  // Число, кратное 0x1000
    result += big_number;
    
    // LUI + ADDI для чисел, не кратных 0x1000
    int very_big = 0x12345FFF;    // Требует LUI + ADDI
    result += very_big;
    
    // AUIPC - Add Upper Immediate to PC
    // Используется для позиционно-независимого кода
    // Обращение к статической переменной может сгенерировать AUIPC
    static int static_var = 42;
    result += static_var;
    
    // Обращение к глобальной переменной (если объявлена вне функции)
    // тоже может использовать AUIPC
    extern int global_var;
    result += global_var;
    
    return result;
}

// Глобальная переменная для демонстрации
int global_var = 100;

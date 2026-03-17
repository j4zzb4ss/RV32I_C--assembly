static int helper_function(int x) {
    return x * 2;
}

int j_type_examples(int a) {
    int result = 0;
    
    // JAL - прямой вызов функции
    // Инструкция jal с вычисленным смещением
    result = helper_function(a);
    
    // JALR - косвенный вызов через указатель
    int (*func_ptr)(int) = &helper_function;
    result += func_ptr(a * 2);
    
    // JALR для возврата из функции (jr ra)
    // Это специальный случай jalr с регистром ra
    
    return result;
}

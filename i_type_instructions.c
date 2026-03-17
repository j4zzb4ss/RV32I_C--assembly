int i_type_operations(int a, int *ptr) {
    int result = 0;
    
    // Арифметика с immediate
    result = a + 42;           // ADDI
    
    // Логические операции с immediate
    result = a & 0xFF;         // ANDI
    result = a | 0xF0;         // ORI
    result = a ^ 0xAAAA;       // XORI
    
    // Сдвиги с immediate
    result = a << 3;           // SLLI
    result = a >> 2;           // SRAI (арифметический для signed)
    
    // Загрузка из памяти (immediate offset)
    result = ptr[5];           
    
    return result;
}

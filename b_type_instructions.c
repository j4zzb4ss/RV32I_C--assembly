int b_type_operations(int a, int b) {
    int result = 0;
    
    // BEQ - branch if equal (переход, если равно)
    if (a == b) {
        result += 100;
    }
    
    // BNE - branch if not equal (переход, если не равно)
    if (a != b) {
        result += 200;
    }
    
    // BLT - branch if less than (переход, если меньше, signed)
    if (a < b) {
        result += 300;
    }
    
    // BGE - branch if greater or equal (переход, если больше или равно, signed)
    if (a >= b) {
        result += 400;
    }
    
    // BLTU - branch if less than unsigned (переход, если меньше, unsigned)
    unsigned int ua = a;
    unsigned int ub = b;
    if (ua < ub) {
        result += 500;
    }
    
    // BGEU - branch if greater or equal unsigned
    if (ua >= ub) {
        result += 600;
    }
    
    // Цикл for тоже использует B-type для проверки условия
    for (int i = 0; i < a; i++) {
        result += i;
    }
    
    return result;
}

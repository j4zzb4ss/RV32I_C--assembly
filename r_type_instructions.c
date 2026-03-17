// R-type: add, sub, and, or, xor, sll, srl, sra, slt, sltu
int r_type_operations(int a, int b) {
    int result = 0;
    
    // Арифметические
    result += a + b;        // add
    result += a - b;        // sub
    
    // Логические
    result += a & b;        // and
    result += a | b;        // or
    result += a ^ b;        // xor
    
    // Сдвиги
    result += a << (b & 31);   // sll
    result += a >> (b & 31);   // srl (логический для unsigned)
    
    // Сравнения
    if (a < b) result += 1;    // slt
    if ((unsigned)a < (unsigned)b) result += 1; // sltu
    
    return result;
}

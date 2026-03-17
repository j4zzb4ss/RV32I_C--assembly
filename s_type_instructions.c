void s_type_operations(int *arr, int value) {
    // SW - сохранение слова (4 байта) с разными смещениями
    arr[0] = value;           // sw с offset 0
    arr[5] = value + 1;       // sw с offset 20 (5 * 4)
    
    // SH - сохранение полуслова (2 байта)
    short *sptr = (short*)arr;
    sptr[2] = value;          // sh с offset 4 (2 * 2)
    
    // SB - сохранение байта
    char *cptr = (char*)arr;
    cptr[3] = value;          // sb с offset 3
}

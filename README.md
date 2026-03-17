# RV32I_C->assembly
Покрываем инструкции RISC-V каждого типа.

В этом репозитории можно посмотреть код на **С** и соответствующий ему код на **языке ассемблера для RISC-V**.

### Типы инструкций RV32I

R	**(Register)**	add, sub, and, or, xor, sll, srl, sra, slt, sltu	// Операции над регистрами

I	**(Immediate)**	addi, andi, ori, xori, slli, srli, srai, lb, lh, lw, lbu, lhu, jalr	// Работа с константами, загрузка из памяти

S	**(Store)**	sb, sh, sw	// Сохранение в память

B	**(Branch)**	beq, bne, blt, bge, bltu, bgeu	// Условные переходы (if, циклы)

U	**(Upper immediate)**	lui, auipc	// Загрузка больших констант (20 бит), адресация

J	**(Jump)**	jal, jalr	// Вызов функций и возврат

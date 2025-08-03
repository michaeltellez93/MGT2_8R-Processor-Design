; --- Example Assembly File ---
    .org 0x0000          ; (1) Start address (directive)
start:                   ; (2) Label
    LOAD R1, 0x10        ; (3) Instruction
    ADD  R1, R1, R2
    STORE R1, 0x20
    JMP  start           ; Branch to label

data_section:            ; (2) Another label
    .word 0x1234         ; (1) Data directive
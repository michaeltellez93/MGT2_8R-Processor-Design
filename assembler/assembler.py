def handle_org(line, current_address):
    """Handle the .ORG directive."""
    pass

def handle_byte(line, current_address):
    """Handle the .BYTE directive."""
    pass

op_codes = {
    "LD":   "0000",
    "LDI":  "0001",
    "ST":   "0011",
    "ADD":  "0010",
    "SUB":  "0110",
    "AND":  "0111",
    "OR":   "0101",
    "XOR":  "0100",
    "NOT":  "1100",
    "SLL":  "1101",
    "SRL":  "1111",
    "SRA":  "1110",
    "BEQ":  "1010",
    "BNE":  "1011",
    "JMP":  "1001",
    "JAL":  "1000"
}
directives = {
    ".ORG": handle_org,
    ".BYTE": handle_byte,
}
symbols = {}

file = open("example.asm", "r")
file_buffer = file.readlines()
# with open("example.asm", "r") as file:
#     for num, line in enumerate(file):
#         line = line.split(";")[0].strip()
#         if ":" in line:
#             label = line.split(":")[0].strip()
#             symbols[label] = num
#         print(f"Line {num}: {line}")
    
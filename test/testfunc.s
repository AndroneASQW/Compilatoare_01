__circleArea100 
LDR R1,=314 
MUL R2, R1, R0 
MUL R3, R2, R0 
MOV R0,R3
BX  LR
__mac 
STMFD SP!, {R4} 
MUL R3, R1, R2 
ADD R4, R0, R3 
MOV R0,R4
STMFD SP!, {R4} 
BX  LR
__f 
STMFD SP!, {R4-R7} 
MUL R3, R1, R1 
LDR R4,=4 
MUL R5, R4, R0 
MUL R6, R5, R2 
SUB R7, R3, R6 
MOV R0,R7
STMFD SP!, {R4-R7} 
BX  LR
__pnd 
STMFD SP!, {R4-R9} 
MUL R4, R0, R2 
LDR R5,=100 
SUB R6, R5, R2 
MUL R7, R1, R6 
ADD R8, R4, R7 
MUL R9, R3, R8 
MOV R0,R9
STMFD SP!, {R4-R9} 
BX  LR
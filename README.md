# Assignment 1 : C to ARM compiler

Create using flex and bison a compiler that
* reads a C file from the standard input
* writes the corresponding ARM code to the standard output

The C language support is limited to simple C functions like:

```c
int f(int a, int b, int c) {
  return b * b - 4 * a * c;
}
```

Limitations:
- max 4 parameters, all int;
- return value is int;
- only one statement in function (return)
- only math expressions: + , - , *
- no local variables - just parameters, int constants and parentheses
- limited to available registers R0-R11. Complex expressions that require stack storage are simply not supported


## Prerequisites

Install the following packages (example for Ubuntu)
```
sudo apt install gcc-arm-linux-gnueabi
sudo apt install qemu-user
```

## How to run the skeleton

To build and run: `make`

To clean up: `make clean`

Use `make -n` to list the commands required to build and run the code

## How to submit an assignment

* Create a branch using your name (e.g. john.doe) : ```git checkout -b john.doe```
* Complete the "TODO" in the source code
* Push the code on the new branch : ```git push -u origin john.doe```

## Example of C functions and generated code

```
; int f(int a, int b, int c) {
;     return b * b - 4 * a * c ; 
;     }
;  
_f
	STMFD SP!, {R4}
	MUL   R3, R1, R1
	LDR   R4, =4
	MUL   R4, R4, R0
	MUL   R4, R4, R2
	SUB   R3, R3, R4
	MOV   R0, R3
	LDMFD SP!, {R4}
	BX    LR

; int volume(int pi, int r, int height) {
;     return pi * r * r * height; 
;     }
;  
_volume
	MUL   R3, R0, R1
	MUL   R3, R3, R1
	MUL   R3, R3, R2
	MOV   R0, R3
	BX    LR

; int Taylor_1_div_x(int x) {
;     return 1-(x-1)+(x-1)*(x-1)-(x-1)*(x-1)*(x-1) ; 
;     }
;  
_Taylor_1_div_x
	LDR   R1, =1
	LDR   R2, =1
	SUB   R2, R0, R2
	SUB   R1, R1, R2
	LDR   R2, =1
	SUB   R2, R0, R2
	LDR   R3, =1
	SUB   R3, R0, R3
	MUL   R2, R2, R3
	ADD   R1, R1, R2
	LDR   R2, =1
	SUB   R2, R0, R2
	LDR   R3, =1
	SUB   R3, R0, R3
	MUL   R2, R2, R3
	LDR   R3, =1
	SUB   R3, R0, R3
	MUL   R2, R2, R3
	SUB   R1, R1, R2
	MOV   R0, R1
	BX    LR

; int x(int a, int b, int c, int d) {
;     return (d-a)*0-((a-b)*10+((b-c)*20-(c-d)*30)) ; 
;     }
;  
_x
	STMFD SP!, {R4-R7}
	SUB   R4, R3, R0
	LDR   R5, =0
	MUL   R4, R4, R5
	SUB   R5, R0, R1
	LDR   R6, =10
	MUL   R5, R5, R6
	SUB   R6, R1, R2
	LDR   R7, =20
	MUL   R6, R6, R7
	SUB   R7, R2, R3
	LDR   R8, =30
	MUL   R7, R7, R8
	SUB   R6, R6, R7
	ADD   R5, R5, R6
	SUB   R4, R4, R5
	MOV   R0, R4
	LDMFD SP!, {R4-R7}
	BX    LR
```
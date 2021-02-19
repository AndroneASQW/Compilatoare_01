/*

#
# C to ARM-32 bit Compiler
#
# Is able to compile simple C functions, for example:
#
# Input:

int circleArea100(int radius)
{
	return 314 * radius * radius;
}

int mac(int a, int b, int c)
{
	return a + b * c;
}

int f(int a, int b, int c) {
   return b * b - 4 * a * c;
   }

int pnd(int n1, int n2, int p, int Multiplier) {
   return Multiplier * (n1 * p + n2 * (100 - p));
   }

   
# Output:

.global circleArea100
circleArea100:
	LDR   R1, =314     
	MUL   R2, R1, R0    
	MUL   R3, R2, R0    
	MOV   R0, R3
	BX    LR
	
.global mac
mac:
	STMFD SP!, {R4}
	MUL   R3, R1, R2     
	ADD   R4, R0, R3    
	MOV   R0, R4
	LDMFD SP!, {R4}
	BX    LR

.global f
f:
	STMFD SP!, {R4-R7}
	MUL   R3, R1, R1
	LDR   R4, =4
	MUL   R5, R4, R0
	MUL   R6, R5, R2
	SUB   R7, R3, R6
	MOV   R0, R7
	LDMFD SP!, {R4-R7}
	BX    LR

.global pnd
pnd:
	STMFD SP!, {R4-R9}
	MUL   R4, R0, R2
	LDR   R5, =100
	SUB   R6, R5, R2
	MUL   R7, R1, R6
	ADD   R8, R4, R7
	MUL   R9, R3, R8
	MOV   R0, R9
	LDMFD SP!, {R4-R9}
	BX    LR

	
# Limitations:
# - 0 to 4 parameters, all int;
# - return value is int;
# - only one statement in function (return)
# - only math expressions: + , - , *
# - no local variables - just parameters, int constants and parentheses
# - no register spill - expressions requiring more than 12 arguments and operands are not supported
#

ARM - 32 bit - Simplified Procedure Call Standard (ARM EABI compatible)

- Input arguments: R0 to R3 - supports up to 4 integer arguments
- Return value: R0
- Scratch registers (volatile): R0 to R3, when they are not used by arguments
- Local variables (non volatile, callee saved): R4 to R11
- Data types: int - 32 bit signed integer
- Return using the BX LR instruction for Thumb compatibility

ARM instruction subset to be used:

	MOV   Rd, Rs        "Move" -> Rd = Rs
	ADD   Rd, Rs1, Rs2  "Add" -> Rd = Rs1 + Rs2
	SUB   Rd, Rs1, Rs2  "Subtract" -> Rd = Rs1 - Rs2
	MUL   Rd, Rs1, Rs2  "Multiply" -> Rd = Rs1 * Rs2 . Rd and Rs1 must be different registers
	LDR   Rd, =constant "Load Register" -> Rd = constant
	STMFD SP!, {Regs}   "Store Multiple Full Stack Decrement" -> Push registers on stack
	LDMFD SP!, {Regs}   "Load Multiple Full Stack Decrement" -> Pop registers from stack
	BX    LR            "Branch exchange to link register" -> return from subroutine call

 */

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "helper.h"

#define MAX_FUNCTIONS 10
#define MAX_ARGUMENTS 4
#define MAX_NAME_LENGTH 20

int yylex(void);
void yyerror(char *);
extern int yylineno;

/* TODO: Add global variables and data structures here */
int arguments_nb = 0;
int arguments_nb_functions[MAX_FUNCTIONS];
int functions_nb = 0;
int reg_nb = 0;
int execute_order = 0;

char *arguments_identifier[MAX_ARGUMENTS];
char function_identifier[][MAX_NAME_LENGTH];
char functions_table[MAX_FUNCTIONS][MAX_NAME_LENGTH];
char arm_code[300][100];
int save_to_stack = 0;



%}

%union{
	/* TODO: Add types for semantic values */
	int nb;
	char *name;
}

/* Declare %token and %type here */
%left '+' '-' 
%left '*' 


%token INT
%token RETURN
%token<name> IDENTIFIER
%token<nb> VAR_NB

%type<nb> value
%type<nb> result
%type<nb> exp


/* Simplified C grammar */
%%
source:    /* empty string */
        | source function
;

function:  /* TODO: Add grammar rules to parse a function, argument, expressions etc here */
		F_NAME '('ARGUMENTS ')' '{' BODY '}'
		{
			printf("_%s \n",function_identifier[functions_nb-1]);
			/*CHECK IF MORE THAN 4 REGISTERS ARE USED*/
			reg_nb--;

			if (reg_nb>11)
				yyerror("Register violation!");
			else
			{
				if (reg_nb>3){
					save_to_stack = 1;
					load_unload_stack(reg_nb);
				}
				else 
					save_to_stack = 0;
				
				for(int i=0;i<execute_order;i++){
					printf("%s",arm_code[i]);
				}
				
				printf("MOV R0,R%d\n",reg_nb);
				if(save_to_stack){
					load_unload_stack(reg_nb);	
				}

				printf("BX  LR\n");
				reg_nb = 0;
				execute_order = 0;
				arguments_nb = 0;
			}
		}
;

F_NAME :INT IDENTIFIER
	{
		sprintf(functions_table[functions_nb],"%s",$2);
		sprintf(function_identifier[functions_nb++],"_%s",$2);  //check here
	}
;

ARGUMENTS : ARGUMENT
		| ARGUMENTS ',' ARGUMENT
;

ARGUMENT : INT IDENTIFIER 
	{
		arguments_identifier[arguments_nb++] = $2;
		reg_nb = arguments_nb;
	}
;

BODY: RETURN exp ';'
;

exp :  exp '+' result
		{
			sprintf(arm_code[execute_order],"ADD R%d, R%d, R%d \n",reg_nb,$1,$3);
			execute_order++;
			$$ = reg_nb;
			reg_nb++;
		}

	  | exp '-' result
		{
			sprintf(arm_code[execute_order++],"SUB R%d, R%d, R%d \n",reg_nb,$1,$3);
			$$ = reg_nb++;
		}
	  | result
;

result : result '*' value
	{
		sprintf(arm_code[execute_order++],"MUL R%d, R%d, R%d \n",reg_nb,$1,$3);
		$$ = reg_nb;
		reg_nb++;
	}
	|value
;

value :IDENTIFIER
	{
		for(int i=0;i < arguments_nb;i++)
		   if(strcmp($1, arguments_identifier[i])==0)
		   	$$ = i;
	}
	|VAR_NB
	{
		sprintf(arm_code[execute_order++],"LDR R%d,=%d \n",reg_nb,$1);
		$$ = reg_nb++;

	}
	| '(' exp ')' {
		$$ = $2;
	}
;
	   
%%

void yyerror (char *s)  /* Called by yyparse on error */
{
	fprintf (stderr, "Error in line %d : %s\n", yylineno, s);
	exit(1);
}

int main(int argc, const char **argv)
{
	/* TODO: Add initialization code here */
	yyparse();
	/* TODO: Add any additional code needed here */
	return 0;
}


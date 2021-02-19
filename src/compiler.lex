/*
 Tokens for a simple expression calculator
*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "helper.h"
#include "compiler.tab.h"


%}

%option noyywrap
%option yylineno

%%

[ \t\n\r]	/* Skip whitespace */

	/* TODO: Add lexer rules here */
[-+*(){},;]	      return *yytext; /* Special characters */
int                    {return INT;} 
return                 {return RETURN;}
[_a-zA-Z]([_a-zA-Z]|[0-9])*  {yylval.name = strdup(yytext) ; return(IDENTIFIER);}
[0-9]+("."[0-9]+)?    	      {yylval.nb = atoi(yytext)   ; return(VAR_NB);}

. 	fprintf(stderr, "Error in line %d : Invalid character: %s\n", yylineno, yytext); exit(1);

%%

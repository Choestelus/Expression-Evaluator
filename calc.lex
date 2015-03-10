%option noyywrap

%{
#include "calc.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

white [ \t]+
digit [0-9]
integer {digit}+
hex [0-9A-F]+h
bin [0-1]+b
exponent [eE][+-]?{integer}
real {integer}("."{integer})?{exponent}?

%%

{white} { }
{real} { yylval=atof(yytext);
 return NUMBER;
}
{hex} {
    int insize = strlen(yytext);
    yytext[insize-1] = '\0';
    sscanf(yytext, "%x", &yylval);
    return HEXNUM;
}

"+" return PLUS;
"-" return MINUS;
"*" return TIMES;
"/" return DIVIDE;
"^" return POWER;
"(" return LEFT;
")" return RIGHT;
"\n" return END;
"\\" return MOD;
"[" return BLEFT;
"]" return BRIGHT;
"{" return CLEFT;
"}" return CRIGHT;
"SHOW" return SHOW;
"$size" return SIZE;

%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
int regis[10]={0};
int acc;
int i=0;


%}

%token NUMBER
%token PLUS MINUS TIMES DIVIDE POWER MOD
%token LEFT RIGHT
%token BLEFT BRIGHT
%token CLEFT CRIGHT
%token END
%token REG SHOW COPY TO PUSH POP

%left PLUS MINUS
%left TIMES DIVIDE MOD
%left NEG
%right POWER

%start Input
%%

Input:

     | Input Line
;

Line:
     END
	| Expression END { printf("Result: %d\n", $1); }
	| SHOW REG NUMBER END { printf("Register NO. %d = %d\n",$3,regis[$3]); }
	| COPY REG NUMBER TO REG NUMBER END {regis[$6]=regis[$3]; }
;

Expression:
     NUMBER { $$=$1; }
	| Expression PLUS Expression { $$=$1+$3; acc=$1+$3; }
	| Expression MINUS Expression { $$=$1-$3; acc=$1-$3; }
	| Expression TIMES Expression { $$=$1*$3; acc=$1*$3; }
	| Expression DIVIDE Expression { $$=$1/$3; acc=$1/$3; }
	| Expression MOD Expression { $$=$1%$3; acc=$1%$3; }
	| MINUS Expression %prec NEG { $$=-$2; acc=-$2; }
	| Expression POWER Expression { $$=pow($1,$3); acc=pow($1,$3);}
	| LEFT Expression RIGHT { $$=$2; acc=$2;}
    	| BLEFT Expression BRIGHT { $$=$2; acc=$2; }
   	| CLEFT Expression CRIGHT { $$=$2;  acc=$2; } 
;

%%

int yyerror(char *s) {
  printf("%s\n", s);
}

int main() {
  if (yyparse())
     fprintf(stderr, "Successful parsing.\n");
  else
     fprintf(stderr, "error found.\n");
}

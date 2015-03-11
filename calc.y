%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>

#define YYSTYPE int64_t

int64_t regis[10]={0};
int64_t acc,top,temppop;
struct stack
{
    int64_t info;
    struct stack *link;
};

struct stack *start=NULL;

%}

%token NUMBER
%token BINNUM
%token HEXNUM
%token SHOW SIZE ACC
%token PLUS MINUS TIMES DIVIDE POWER MOD
%token LEFT RIGHT
%token BLEFT BRIGHT
%token CLEFT CRIGHT
%token END
%token REG COPY TO PUSH POP TOP

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
	| Expression END { printf("Result: %"PRId64"\n", $1); acc=$1; }
	| COPY Reg END {}
    | PUSH Reg { push($2); display(); }
    | POP REG NUMBER { pop($3); }
;

Expression:
     NUMBER { $$=$1; }
    | HEXNUM { $$=$1; }
	| Expression PLUS Expression { $$=$1+$3; }
	| Expression MINUS Expression { $$=$1-$3; }
	| Expression TIMES Expression { $$=$1*$3; }
	| Expression DIVIDE Expression { $$=$1/$3; }
	| Expression MOD Expression { $$=$1%$3; }
	| MINUS Expression %prec NEG { $$=-$2; }
	| Expression POWER Expression { $$=pow($1,$3); }
	| LEFT Expression RIGHT { $$=$2; }
    | BLEFT Expression BRIGHT { $$=$2; }
    | CLEFT Expression CRIGHT { $$=$2; }
    | SHOW Reg { $$=$2; }
;

Reg:
    SIZE { $$=getSize(); }
    | REG NUMBER { $$=regis[$2]; }
    | ACC { $$=acc; }
    | TOP { top=getTop(); $$=top; }
    | REG NUMBER TO REG NUMBER {regis[$5]=regis[$2]; }
    | ACC TO REG NUMBER {regis[$4]=acc; }
    | SIZE TO REG NUMBER {regis[$4]=getSize(); }
    | TOP TO REG NUMBER {regis[$4]=getTop(); }
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


push(int64_t data)
{
    struct stack *new,*temp;
    int64_t i=0;

    new=(struct stack *)malloc(sizeof(struct stack));
    new->info = data;
    new->link=start;
    start=new;
}

pop(int64_t id)
{
    struct stack *temp,*temp2;
    int64_t i=0;

    for(temp=start;temp!=NULL;temp=temp->link)
    {
        i++;
    }

    if(i==0)
    {
        fprintf(stderr, "error: stack empty.\n");
    }

    else
    {
        regis[id] = getTop();
        temp2=start->link;
        start=temp2;
        printf("\n***The value has been poped***\n");
    }
}

display()
{
    struct stack *temp;
    printf("\n****Stack Values****\n");
    printf("TOP : %"PRId64"\n", getTop());
    for(temp=start;temp!=NULL;temp=temp->link)
    {
        printf("%"PRId64"\n",temp->info);
    }
}

getSize()
{
    struct stack *temp;
    int64_t i=0;
    for(temp=start;temp!=NULL;temp=temp->link)
    {
        i++;
    }
    return i;
}

getTop()
{
    return start->info;
}

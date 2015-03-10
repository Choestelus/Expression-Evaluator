%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

struct stack
{
    int info;
    struct stack *link;
};

struct stack *start=NULL;
%}

%token NUMBER
%token SHOW SIZE
%token PLUS MINUS TIMES DIVIDE POWER MOD
%token LEFT RIGHT
%token END

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
;

Expression:
    NUMBER { $$=$1; }
    | Expression PLUS Expression { $$=$1+$3; }
    | Expression MINUS Expression { $$=$1-$3; }
    | Expression TIMES Expression { $$=$1*$3; }
    | Expression DIVIDE Expression { $$=$1/$3; }
    | Expression MOD Expression { $$=$1%$3; }
    | MINUS Expression %prec NEG { $$=-$2; }
    | Expression POWER Expression { $$=pow($1,$3); }
    | LEFT Expression RIGHT { $$=$2; }
    | SHOW Reg { $$=$2; }
;

Reg:
    SIZE { $$=getSize(); }

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


push()
{
    struct stack *new,*temp;
    int i=0;

    new=(struct stack *)malloc(sizeof(struct stack));
    printf("Enter value for stack: ");
    scanf("%d",&new->info);
    new->link=start;
    start=new;
}

pop()
{
    struct stack *temp,*temp2;
    int i=0;
    for(temp=start;temp!=NULL;temp=temp->link)
    {
        i++;
    }
    
    if(i==0)
    {
        printf("Stack Empty");
    }
    
    else
    {
        temp2=start->link;
        start=temp2;
        printf("\n***The value has been poped***\n");
    }
}

display()
{
    struct stack *temp;
    printf("\n****Stack Values****\n");
    for(temp=start;temp!=NULL;temp=temp->link)
    {
        printf("%d\n",temp->info);
    }
}

getSize()
{
  struct stack *temp;
  int i=0;
  for(temp=start;temp!=NULL;temp=temp->link)
    {
        i++;
    }
    return i;
}

calc: calc.y calcedit.lex
	cp calcedit.lex calc.lex
	bison -d calc.y
	flex  -o calc.lex.c calc.lex
	gcc  -o calc calc.lex.c calc.tab.c -lfl -lm
clean:
	rm calc calc.tab.* calc.lex.c

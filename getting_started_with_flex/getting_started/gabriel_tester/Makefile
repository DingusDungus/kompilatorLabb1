compiler: lex.yy.c 
		gcc -ocompiler lex.yy.c main.c
lex.yy.c:
		flex lexer.flex
clean:
		rm -f lex.yy.c compiler
		flex lexer.flex
		gcc -ocompiler lex.yy.c main.c
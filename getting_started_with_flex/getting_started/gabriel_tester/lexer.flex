%top{
#define YYSTYPE int
}
%option noyywrap
%x  initString
%%
["].*["]        {printf("This is a string: %s\n", yytext);}
"for"           {printf("FOR loop");}
"if"            {printf("IF statement");}
%%
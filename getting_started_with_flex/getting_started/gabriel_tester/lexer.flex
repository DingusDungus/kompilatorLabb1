%top{
#define YYSTYPE int
}
%option noyywrap
%x STRING
%%
\n             {BEGIN INITIAL;}
"for"             {printf("For-loop\n");}
[^"]*           { printf("OTHER: %s\n",yytext);}    /* Any character */
["]             {BEGIN STRING;}
<STRING>["]      {BEGIN INITIAL;}
<STRING>[^"]*   {printf("STRING: %s\n", yytext);}
%%
%top{
#include "parser.tab.hh"
#define YY_DECL yy::parser::symbol_type yylex()
#include "Node.h"
}
%option noyywrap nounput batch noinput stack
%%

"+"                             {return yy::parser::make_PLUSOP(yytext);}
"*"                             {return yy::parser::make_MULTOP(yytext);}
"("                             {return yy::parser::make_LP(yytext);}
")"                             {return yy::parser::make_RP(yytext);}
"["                             {return yy::parser::make_LBRACKET(yytext);}
"]"                             {return yy::parser::make_RBRACKET(yytext);}
"{"                             {return yy::parser::make_LBRACE(yytext);}
"}"                             {return yy::parser::make_RBRACE(yytext);}
"for"                           {return yy::parser::make_FOR(yytext);}
"if"                            {return yy::parser::make_IF(yytext);}
"while"                         {return yy::parser::make_WHILE(yytext);}
"main"                          {return yy::parser::make_MAIN(yytext);}
"extends"                       {return yy::parser::make_EXTENDS(yytext);}
["].*["]                        {return yy::parser::make_STRING(yytext);}
"boolean"                       {return yy::parser::make_BOOLEAN(yytext);}
[a-zA-Z_][a-zA-Z0-9_]*          {return yy::parser::make_IDENTIFIER(yytext);}

0|[1-9][0-9]*             {return yy::parser::make_INT(yytext);}



[ \t\n]+                  {}

<<EOF>>                 return yy::parser::make_END();
%%
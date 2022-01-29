%top{
#include "parser.tab.hh"
#define YY_DECL yy::parser::symbol_type yylex()
#include "Node.h"
}
%option noyywrap nounput batch noinput stack
%%

"+"                             {return yy::parser::make_PLUSOP(yytext);}
"-"                             {return yy::parser::make_MINUS(yytext);}
"*"                             {return yy::parser::make_MULTOP(yytext);}
"="                             {return yy::parser::make_ASSIGN(yytext);}
"=="                            {return yy::parser::make_EQUAL(yytext);}
"!"                             {return yy::parser::make_NOT(yytext);}
"<"                             {return yy::parser::make_LESSER(yytext);}
"&&"                            {return yy::parser::make_AND(yytext);}
"."                             {return yy::parser::make_DOT(yytext);}
","                             {return yy::parser::make_COMMA(yytext);}
";"                             {return yy::parser::make_SEMI_C(yytext);}
"("                             {return yy::parser::make_LP(yytext);}
")"                             {return yy::parser::make_RP(yytext);}
"["                             {return yy::parser::make_LBRACKET(yytext);}
"]"                             {return yy::parser::make_RBRACKET(yytext);}
"{"                             {return yy::parser::make_LBRACE(yytext);}
"}"                             {return yy::parser::make_RBRACE(yytext);}
"for"                           {return yy::parser::make_FOR(yytext);}
"if"                            {return yy::parser::make_IF(yytext);}    
"else"                          {return yy::parser::make_ELSE(yytext);}
"while"                         {return yy::parser::make_WHILE(yytext);}
"main"                          {return yy::parser::make_MAIN(yytext);}
"extends"                       {return yy::parser::make_EXTENDS(yytext);}
"public"                        {return yy::parser::make_PUBLIC(yytext);}
"void"                          {return yy::parser::make_VOID(yytext);}  
"class"                         {return yy::parser::make_CLASS(yytext);}  
"return"                        {return yy::parser::make_RETURN(yytext);}
"String"                        {return yy::parser::make_STRING(yytext);}
"boolean"                       {return yy::parser::make_BOOLEAN(yytext);}
"true"                          {return yy::parser::make_TRUE(yytext);}
"false"                         {return yy::parser::make_FALSE(yytext);}
"int"                           {return yy::parser::make_INTEGER(yytext);}
"this"                          {return yy::parser::make_THIS(yytext);}
"new"                           {return yy::parser::make_NEW(yytext);}
"length"                        {return yy::parser::make_LENGTH(yytext);}
"System.out.println"            {return yy::parser::make_SOP(yytext);}
[a-zA-Z_][a-zA-Z0-9_]*          {return yy::parser::make_IDENTIFIER(yytext);}

0|[+|-]?[1-9][0-9]*             {return yy::parser::make_INT(yytext);}
["].*["]                        {return yy::parser::make_STRINGVAL(yytext);}

[ \t\n]+                        {}

<<EOF>>                 return yy::parser::make_END();
%%
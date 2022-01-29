%top{
#include "parser.tab.hh"
#define YY_DECL yy::parser::symbol_type yylex()
#include "Node.h"
}
%option noyywrap nounput batch noinput stack
%%

"+"                             {printf("AddOp\n"); return yy::parser::make_PLUSOP(yytext);}
"-"                             {printf("MinusOp\n"); return yy::parser::make_MINUS(yytext);}
"*"                             {printf("MultOp\n"); return yy::parser::make_MULTOP(yytext);}
"/"                             {printf("DivOp\n"); return yy::parser::make_DIVOP(yytext);}
"="                             {printf("AssignOp\n"); return yy::parser::make_ASSIGN(yytext);}
"=="                            {printf("EqualOp\n"); return yy::parser::make_EQUAL(yytext);}
"!"                             {printf("NotOp\n"); return yy::parser::make_NOT(yytext);}
"<"                             {printf("LesserOp\n"); return yy::parser::make_LESSER(yytext);}
">"                             {printf("GreaterOp\n"); return yy::parser::make_GREATER(yytext);}
"&&"                            {printf("AndOp\n"); return yy::parser::make_AND(yytext);}
"||"                            {printf("OrOp\n"); return yy::parser::make_OR(yytext);}
"."                             {printf("Dot\n"); return yy::parser::make_DOT(yytext);}
","                             {printf("Comma\n"); return yy::parser::make_COMMA(yytext);}
";"                             {printf("Semi_Colon\n"); return yy::parser::make_SEMI_C(yytext);}
"("                             {printf("LeftParan\n"); return yy::parser::make_LP(yytext);}
")"                             {printf("RightParan\n"); return yy::parser::make_RP(yytext);}
"["                             {printf("LeftBracket\n"); return yy::parser::make_LBRACKET(yytext);}
"]"                             {printf("RightBracket\n"); return yy::parser::make_RBRACKET(yytext);}
"{"                             {printf("leftBrace\n"); return yy::parser::make_LBRACE(yytext);}
"}"                             {printf("RightBrace\n"); return yy::parser::make_RBRACE(yytext);}
"for"                           {printf("ForOp\n"); return yy::parser::make_FOR(yytext);}
"if"                            {printf("ifOp\n"); return yy::parser::make_IF(yytext);}
"else"                          {printf("ElseOp\n"); return yy::parser::make_ELSE(yytext);}
"while"                         {printf("WhileOp\n"); return yy::parser::make_WHILE(yytext);}
"main"                          {printf("Main\n"); return yy::parser::make_MAIN(yytext);}
"extends"                       {printf("Extends\n"); return yy::parser::make_EXTENDS(yytext);}
"static"                        {printf("Extends\n"); return yy::parser::make_STATIC(yytext);}
"public"                        {printf("public\n"); return yy::parser::make_PUBLIC(yytext);}
"void"                          {printf("Void\n"); return yy::parser::make_VOID(yytext);}
"class"                         {printf("class\n"); return yy::parser::make_CLASS(yytext);}
"return"                        {printf("return\n"); return yy::parser::make_RETURN(yytext);}
"String"                        {printf("String\n"); return yy::parser::make_STRING(yytext);}
"boolean"                       {printf("Boolean\n"); return yy::parser::make_BOOLEAN(yytext);}
"true"                          {printf("True\n"); return yy::parser::make_TRUE(yytext);}
"false"                         {printf("False\n"); return yy::parser::make_FALSE(yytext);}
"int"                           {printf("Int\n"); return yy::parser::make_INT(yytext);}
"this"                          {printf("This\n"); return yy::parser::make_THIS(yytext);}
"new"                           {printf("New\n"); return yy::parser::make_NEW(yytext);}
"length"                        {printf("Length\n"); return yy::parser::make_LENGTH(yytext);}
"System.out.println"            {printf("SOP\n"); return yy::parser::make_SOP(yytext);}
[a-zA-Z_][a-zA-Z0-9_]*          {printf("identifier: %s\n", yytext); return yy::parser::make_IDENTIFIER(yytext);}

0|[+|-]?[1-9][0-9]*             {printf("Integer: %s\n", yytext); return yy::parser::make_INTEGER(yytext);}
["][.\n]*["]                    {printf("Stringval: %s\n", yytext); return yy::parser::make_STRINGVAL(yytext);}

"/""/"[^\n\r]*[\n]              {printf("Comment\n"); }
"/""*"[^\n\r]*"*""/"            {printf("Comment\n"); }
[ \t\n]+                        {printf("Whitespace\n"); }

<<EOF>>                 {printf("End\n"); return yy::parser::make_END();}
%%

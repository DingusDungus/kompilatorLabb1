%top{
#define YYSTYPE int
#include <iostream>
}
%option noyywrap
%%
[+|-]?[1-9][0-9]*\.?[0-9]+|[1-9][0-9]*\.|0\.[0-9]+ {std::cout << "This is a float!\n";}
%%
%skeleton "lalr1.cc" 
%defines
%define parse.error verbose
%define api.value.type variant
%define api.token.constructor

%code requires{
  #include <string>
  #include "Node.h"
}
%code{
  #define YY_DECL yy::parser::symbol_type yylex()

  YY_DECL;
  
  Node* root;
  
}
// definition of set of tokens. All tokens are of type string
%token <std::string> RP RBRACE RBRACKET
%token <std::string> STRING BOOLEAN VAR INT NEW THIS LENGTH
%token <std::string> STRINGVAL INTEGER TRUE FALSE
%token <std::string> FOR IF ELSE WHILE
%token <std::string> AND LESSER EQUAL NOT GREATER OR
%token <std::string> MAIN EXTENDS PUBLIC VOID RETURN CLASS SOP
%token <std::string> DOT COMMA SEMI_C
%token END 0 "end of file"

%left <std::string> LP LBRACE LBRACKET 
%left <std::string> PLUSOP MINUS MULTOP DIVOP
%left <std::string> AND LESSER EQUAL GREATER OR
%right <std::string> NOT ASSIGN


// definition of the production rules. All production rules are of type Node
%type <Node *> expression addExpression multExpression factor
%type <Node *> mainClass classDeclaration identifier 

%start <Node *> goal

%%
goal: 
{

}
expression: addExpression 
                          { /*  
                                Here we create the root node (named program), then we add the content of addExpression (accessed through $1) as a child of the root node. 
                                The "root" is a reference to the root node. 
                            */
                            $$ = new Node("Expression", "");
                            $$->children.push_back($1);
                            root = $$;
                            printf("r1 ");
                          };

addExpression: multExpression { $$ = $1; printf("r2 "); /*simply return the content of multExpression*/}
             | addExpression PLUSOP multExpression {  /*
                                                  Create a subtree that corresponds to the AddExpressions
                                                  The root of the subtree is AddExpression
                                                  The childs of the AddExpression subtree are the left hand side (addExpression accessed through $1) and right hand side of the expression (multExpression accessed through $3)
                                                */
                            $$ = new Node("AddExpression", "");
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                            printf("r3 ");
                          }
      ;

multExpression: factor { $$ = $1; printf("r4 "); /*simply return the content of multExpression*/}
              | multExpression MULTOP factor { /*
                                                  Create a subtree that corresponds to the MultExpression
                                                  The root of the subtree is MultExpression
                                                  The childs of the MultExpression subtree are the left hand side (multExpression accessed through $1) and right hand side of the expression (factor accessed through $3)
                                                */
                            $$ = new Node("MultExpression", ""); 
                            $$->children.push_back($1);
                            $$->children.push_back($3);
                            printf("r5 ");
                      }
        ;

factor: INTEGER  {  $$ = new Node("Integer", $1); printf("r6 "); /* Here we create a leaf node Int. The value of the leaf node is $1 */}
    | LP program RP { $$ = $2; printf("r7 "); /* simply return the expression */}
    ;

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
%token <std::string> STRING BOOLEAN IDENTIFIER INT NEW THIS LENGTH
%token <std::string> STRINGVAL INTEGER TRUE FALSE
%token <std::string> FOR IF ELSE WHILE
%token <std::string> AND LESSER EQUAL NOT GREATER OR
%token <std::string> MAIN EXTENDS PUBLIC VOID RETURN CLASS SOP STATIC
%token <std::string> DOT COMMA SEMI_C
%token END 0 "end of file"

%left <std::string> LP LBRACE LBRACKET 
%left <std::string> PLUSOP MINUS MULTOP DIVOP
%left <std::string> AND LESSER EQUAL GREATER OR
%right <std::string> NOT ASSIGN


// definition of the production rules. All production rules are of type Node
%type <Node *> expression addExpression multExpression factor identifier
%type <Node *> mainClass classDeclaration classDeclarations classDeclarationList statement statements statementList varDeclaration varDeclarations
%type <Node *> methodDeclaration methodDeclarations methodDeclarationList typeIdentifier typeIdentifiers typeIdentifierList extendsIdentifier
%type <Node *> expressions expressionList

%start <Node *> goal

%%
goal: mainClass classDeclarations

mainClass:  CLASS identifier LBRACKET PUBLIC STATIC VOID MAIN LP STRING LBRACE RBRACE identifier RP RBRACKET statement RBRACKET {RBRACKET}

typeIdentifier: type identifier

typeIdentifiers:
                /* empty */
                {

                } |
                typeIdentifierList

typeIdentifierList:
                  typeIdentifier |
                  typeIdentifierList COMMA typeIdentifier

expressions:
                /* empty */
                {

                } |
                expressionList

expressionList:
                  expression |
                  expressionList COMMA expression

classDeclaration: CLASS identifier extendsIdentifier LBRACKET varDeclarations methodDeclarations RBRACKET

classDeclarationList:
                    classDeclaration |
                    classDeclarationList classDeclaration

classDeclarations:
                  /* empty */
                  {

                  } |
                  classDeclarationList

methodDeclaration: PUBLIC type identifier LP typeIdentifiers RP LBRACKET varDeclarations statements RETURN expression SEMI_C RBRACKET

methodDeclarationList:  methodDeclaration |
                        methodDeclarationList methodDeclaration

methodDeclarations:
                  /* empty */
                  {

                  } |
                  methodDeclarationList

extendsIdentifier: 
                  /* empty */
                  {

                  } |
                  EXTENDS identifier

varDeclarations:
                /* empty */
                {

                } |
                varDeclarations varDeclaration


varDeclaration: type identifier SEMI_C

type: INT LBRACE RBRACE |
      BOOLEAN |
      INT |
      identifier |
      

statements: 
            /* empty */
            {

            } |
            statementList

statementList:  statement |
                statementList statement

statement:  LBRACKET statements RBRACKET |
            IF  LP  expression RP statement ELSE statement |
            WHILE LP  expression RP statement |
            SOP LP  expression  RP  SEMI_C |
            identifier  ASSIGN  expression SEMI_C
            identifier LBRACE expression RBRACE ASSIGN expression SEMI_C
 
expression: expression AND expression |
            expression OR expression |
            expression LESSER expression |
            expression GREATER expression |
            expression EQUAL expression |
            expression PLUSOP expression |
            expression MINUS expression |
            expression MULTOP expression |
            expression DIVOP expression |
            expression LBRACE expression RBRACE |
            expression DOT LENGTH |
            expression DOT identifier LP expressions RP |
            INTEGER |
            TRUE |
            FALSE |
            identifier |
            THIS |
            NEW INT LBRACE expression RBRACE |
            NEW identifier LP RP |
            NOT expression |
            LP expression RP |

identifier: IDENTIFIER

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

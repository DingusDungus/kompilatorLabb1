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
%type <Node *> expression addExpression multExpression factor identifier type
%type <Node *> mainClass classDeclaration classDeclarations classDeclarationList statement statements statementList varDeclaration varDeclarations
%type <Node *> methodDeclaration methodDeclarations methodDeclarationList typeIdentifier typeIdentifiers typeIdentifierList extendsIdentifier
%type <Node *> expressions expressionList

%type <Node *> goal

%%
goal: mainClass classDeclarations
{
  /*  
    Here we create the root node (named goal), then we add the content of addExpression (accessed through $1) as a child of the root node. 
    The "root" is a reference to the root node. 
  */
  $$ = new Node("Goal", "");
  $$->children.push_back($1);
  root = $$;
  printf("r1 ");
}

mainClass:  CLASS identifier LBRACKET PUBLIC STATIC VOID MAIN LP STRING LBRACE RBRACE identifier RP RBRACKET statement RBRACKET {RBRACKET}

typeIdentifier: type identifier

typeIdentifiers:
                /* empty */
                {
                  $$ = NULL;
                } |
                typeIdentifierList

typeIdentifierList:
                  typeIdentifier |
                  typeIdentifierList COMMA typeIdentifier

expressions:
                /* empty */
                {
                  $$ = NULL;
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
                    $$ = NULL;
                  } |
                  classDeclarationList

methodDeclaration: PUBLIC type identifier LP typeIdentifiers RP LBRACKET varDeclarations statements RETURN expression SEMI_C RBRACKET

methodDeclarationList:  methodDeclaration |
                        methodDeclarationList methodDeclaration

methodDeclarations:
                  /* empty */
                  {
                    $$ = NULL;
                  } |
                  methodDeclarationList

extendsIdentifier: 
                  /* empty */
                  {
                    $$ = NULL;
                  } |
                  EXTENDS identifier

varDeclarations:
                /* empty */
                {
                  $$ = NULL;
                } |
                varDeclarations varDeclaration


varDeclaration: type identifier SEMI_C

type: INT LBRACE RBRACE 
      {
        $$ = $1;
      };|
      BOOLEAN 
      {
        $$ = $1;
      };|
      INT 
      {
        $$ = $1;
      };|
      identifier |
      

statements: 
            /* empty */
            {
              $$ = NULL;
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
 
expression: expression AND expression 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
            };|
            expression OR expression 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
            };|
            expression LESSER expression 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
            };|
            expression GREATER expression 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
            };|
            expression EQUAL expression 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
            };|
            expression PLUSOP expression 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
            };|
            expression MINUS expression 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
            };|
            expression MULTOP expression 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
            };|
            expression DIVOP expression 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
            };|
            expression LBRACE expression RBRACE 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
            };|
            expression DOT LENGTH 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
            };|
            expression DOT identifier LP expressions RP 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($1);
              $$->children.push_back($3);
              $$->children.push_back($5);
            };|
            INTEGER 
            {
              $$ = $1;
            };|
            TRUE 
            {
              $$ = $1;
            };|
            FALSE 
            {
              $$ = $1;
            };|
            identifier 
            {
              $$ = new Node("expression", "");
              $$->children.push_back($1);
            };|
            THIS
            {
              $$ = $1;
            }; |
            NEW INT LBRACE expression RBRACE 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($4);
            };|
            NEW identifier LP RP 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($2);
            };|
            NOT expression 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($2);
            };|
            LP expression RP 
            {
              $$ = new Node("Expression", "");
              $$->children.push_back($2);
            };

identifier: IDENTIFIER
{
  $$ = $1;
};

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

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
%token <std::string> LP RP RBRACE RBRACKET
%token <std::string> STRING BOOLEAN IDENTIFIER INT NEW THIS LENGTH
%token <std::string> STRINGVAL INTEGER TRUE FALSE
%token <std::string> FOR IF ELSE WHILE
%token <std::string> MAIN EXTENDS PUBLIC VOID RETURN CLASS SOP STATIC
%token <std::string> COMMA SEMI_C
%token END 0 "end of file"

%right <std::string> NOT
%left <std::string> AND LESSER EQUAL GREATER OR
%left <std::string> PLUSOP MINUS
%left <std::string> MULTOP DIVOP
%left <std::string> DOT
%right <std::string> ASSIGN
%left <std::string> LBRACE LBRACKET


// definition of the production rules. All production rules are of type Node
%type <Node *> expression identifier type
%type <Node *> mainClass classDeclaration classDeclarations classDeclarationList statement statements statementList varDeclaration varDeclarations
%type <Node *> methodDeclaration methodDeclarations methodDeclarationList typeIdentifier typeIdentifiers typeIdentifierList extendsIdentifier
%type <Node *> expressions expressionList

%type <Node *> goal
%type <Node *> end

%%
goal: mainClass classDeclarations end
{
  /*
    Here we create the root node (named goal), then we add the content of addExpression (accessed through $1) as a child of the root node.
    The "root" is a reference to the root node.
  */
  $$ = new Node("Goal", "");
  $$->children.push_back($1);
  $$->children.push_back($2);
  $$->children.push_back($3);
  root = $$;
}

mainClass:  CLASS identifier LBRACE PUBLIC STATIC VOID MAIN LP STRING LBRACKET RBRACKET identifier RP LBRACE statement RBRACE RBRACE
            {
              $$ = new Node("ExpressionList", "");
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($2);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($12);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($15);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
            };

typeIdentifier: type identifier
                {
                  $$ = new Node("TypeIdentifier", "");
                  $$->children.push_back($1);
                  $$->children.push_back($2);
                };

typeIdentifiers:
                /* empty */
                {
                 $$ = new Node("","");
                };|
                typeIdentifierList
                {
                  $$ = new Node("TypeIdentifiers", "");
                  $$->children.push_back($1);
                };

typeIdentifierList:
                  typeIdentifier
                  {
                    $$ = new Node("TypeIdentifierList", "");
                    $$->children.push_back($1);
                  };|
                  typeIdentifierList COMMA typeIdentifier
                  {
                    $$ = new Node("TypeIdentifierList", "");
                    $$->children.push_back($1);
                    $$->children.push_back(new Node("", ""));
                    $$->children.push_back($3);
                  };

expressions:
                /* empty */
                {
                  $$ = new Node("","");
                };|
                expressionList
                {
                $$ = new Node("Expressions", "");
                $$->children.push_back($1);
              };


expressionList:
              expression
              {
                $$ = new Node("ExpressionList", "");
                $$->children.push_back($1);
              };|
              expressionList COMMA expression
              {
                $$ = new Node("ExpressionList", "");
                $$->children.push_back($1);
                $$->children.push_back(new Node("", ""));
                $$->children.push_back($3);
              };

classDeclaration: CLASS identifier extendsIdentifier LBRACE varDeclarations methodDeclarations RBRACE
                  {
                    $$ = new Node("ClassDeclaration", "");
                    $$->children.push_back(new Node("",""));
                    $$->children.push_back($2);
                    $$->children.push_back($3);
                    $$->children.push_back(new Node("",""));
                    $$->children.push_back($5);
                    $$->children.push_back($6);
                    $$->children.push_back(new Node("",""));
                  };

classDeclarationList:
                    classDeclaration
                    {
                      $$ = new Node("ClassDeclarationList", "");
                      $$->children.push_back($1);
                    };|
                    classDeclarationList classDeclaration
                    {
                      $$ = new Node("ClassDeclarationList", "");
                      $$->children.push_back($1);
                      $$->children.push_back($2);
                    };

classDeclarations:
                  /* empty */
                  {
                    $$ = new Node("","");
                  };|
                  classDeclarationList
                  {
                    $$ = new Node("ClassDeclarations", "");
                    $$->children.push_back($1);
                  };

methodDeclaration:  PUBLIC type identifier LP typeIdentifiers RP LBRACE varDeclarations statements RETURN expression SEMI_C RBRACE
                    {
                      $$ = new Node("MethodDeclaration", "");
                      $$->children.push_back(new Node("",""));
                      $$->children.push_back($2);
                      $$->children.push_back($3);
                      $$->children.push_back(new Node("",""));
                      $$->children.push_back($5);
                      $$->children.push_back(new Node("",""));
                      $$->children.push_back(new Node("",""));
                      $$->children.push_back($8);
                      $$->children.push_back($9);
                      $$->children.push_back(new Node("",""));
                      $$->children.push_back($11);
                      $$->children.push_back(new Node("",""));
                      $$->children.push_back(new Node("",""));
                    };

methodDeclarationList:  methodDeclaration
                        {
                          $$ = new Node("MethodDeclarationList", "");
                          $$->children.push_back($1);
                        };|
                        methodDeclarationList methodDeclaration
                        {
                          $$ = new Node("MethodDeclarationList", "");
                          $$->children.push_back($1);
                          $$->children.push_back($2);
                        };

methodDeclarations:
                  /* empty */
                  {
                    $$ = new Node("","");
                  };|
                  methodDeclarationList
                  {
                    $$ = new Node("MethodDeclarations", "");
                    $$->children.push_back($1);
                  };


extendsIdentifier:
                  /* empty */
                  {
                    $$ = new Node("","");
                  }; |
                  EXTENDS identifier
                  {
                    $$ = new Node("ExtendsIdentifier", "");
                    $$->children.push_back(new Node("",""));
                    $$->children.push_back($2);
                  };

varDeclarations:
                /* empty */
                {
                  $$ = new Node("","");
                }; |
                varDeclarations varDeclaration
                {
                  $$ = new Node("VarDeclarations", "");
                  $$->children.push_back($1);
                  $$->children.push_back($2);
                };



varDeclaration: type identifier SEMI_C
                {
                  $$ = new Node("VarDeclaration", "");
                  $$->children.push_back($1);
                  $$->children.push_back($2);
                  $$->children.push_back(new Node("",""));
                };

type: INT LBRACKET RBRACKET
      {
        $$ = new Node("Type", "");
        $$->children.push_back(new Node("Type",$1));
        $$->children.push_back(new Node("Type",$2));
        $$->children.push_back(new Node("Type",$3));
      };|
      BOOLEAN
      {
        $$ = new Node("Type", $1);
      };|
      INT
      {
        $$ = new Node("Type", $1);
      };|
      identifier
      {
        $$ = new Node("Type", "");
        $$->children.push_back($1);
      };


statements:
            /* empty */
            {
              $$ = new Node("","");
            }; |
            statementList
            {
              $$ = new Node("Statements", "");
              $$->children.push_back($1);
            };

statementList:  statement
                {
                  $$ = new Node("StatementList", "");
                  $$->children.push_back($1);
                };|
                statementList statement
                {
                  $$ = new Node("StatementList", "");
                  $$->children.push_back($1);
                  $$->children.push_back($2);
                };

statement:  LBRACE statements RBRACE
            {
              $$ = new Node("Statement", "");
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($2);
              $$->children.push_back(new Node("", ""));
            };|
            IF  LP  expression RP statement ELSE statement
            {
              $$ = new Node("Statement", "");
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($5);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($7);
            };|
            WHILE LP  expression RP statement
            {
              $$ = new Node("Statement", "");
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($5);
            };|
            SOP LP  expression  RP  SEMI_C
            {
              $$ = new Node("Statement", "");
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
            };|
            identifier  ASSIGN  expression SEMI_C
            {
              $$ = new Node("Statement", "");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
              $$->children.push_back(new Node("", ""));
            };|
            identifier LBRACKET expression RBRACKET ASSIGN expression SEMI_C
            {
              $$ = new Node("Statement", "");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($6);
              $$->children.push_back(new Node("", ""));
            };

expression: expression AND expression
            {
              $$ = new Node("Expression", "AndOp");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
            };|
            expression OR expression
            {
              $$ = new Node("Expression", "OrOp");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
            };|
            expression LESSER expression
            {
              $$ = new Node("Expression", "LesserOp");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
            };|
            expression GREATER expression
            {
              $$ = new Node("Expression", "GreaterOp");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
            };|
            expression EQUAL expression
            {
              $$ = new Node("Expression", "AssignOp");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
            };|
            expression PLUSOP expression
            {
              $$ = new Node("Expression", "AddOp");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
            };|
            expression MINUS expression
            {
              $$ = new Node("Expression", "SubOp");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
            };|
            expression MULTOP expression
            {
              $$ = new Node("Expression", "Multop");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
            };|
            expression DIVOP expression
            {
              $$ = new Node("Expression", "DivOp");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
            };|
            expression LBRACKET expression RBRACKET
            {
              $$ = new Node("Expression", "indexExpression");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
              $$->children.push_back(new Node("", ""));
            };|
            expression DOT LENGTH
            {
              $$ = new Node("Expression", "dotlength");
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
            };|
            expression DOT identifier LP expressions RP
            {
              $$ = new Node("Expression", "DotOp");
              $$->children.push_back($1);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($3);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($5);
              $$->children.push_back(new Node("", ""));
            };|
            INTEGER
            {
              $$ = new Node("Expression", $1);
            };|
            TRUE
            {
              $$ = new Node("Expression", $1);
            };|
            FALSE
            {
              $$ = new Node("Expression", $1);
            };|
            identifier
            {
              $$ = new Node("expression", "");
              $$->children.push_back($1);
            };|
            THIS
            {
              $$ = new Node("Expression", $1);
            }; |
            NEW INT LBRACKET expression RBRACKET
            {
              $$ = new Node("Expression", "newIntArray");
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($4);
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
              $$->children.push_back(new Node("", ""));
            };|
            NEW identifier LP RP
            {
              $$ = new Node("Expression", "newIdentifier");
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($2);
              $$->children.push_back(new Node("", ""));
            };|
            NOT expression
            {
              $$ = new Node("Expression", "NotOp");
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($2);
            };|
            LP expression RP
            {
              $$ = new Node("Expression", "");
              $$->children.push_back(new Node("", ""));
              $$->children.push_back($2);
              $$->children.push_back(new Node("", ""));
            };

identifier: IDENTIFIER
            {
             $$ = new Node("Identifier", $1);
            };

end: END
   {
    $$ = new Node("End", "");
   }

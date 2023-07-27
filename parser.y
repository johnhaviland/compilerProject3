%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbolTable.h"
#include "funcSymbolTable.h"
#include "AST.h"
#include "IRcode.h"
#include "Assembly.h"
#include "registerManager.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;

FILE * IRcode;

void yyerror(const char* s);
char currentScope[50]; 
int result = 0;
int semanticCheckPassed = 1; 
%}

%union {
	int number;
	char character;
	char* string;
	struct AST* ast;
}

%token <string> TYPE
%token <string> ID
%token <character> SEMICOLON
%token <character> EQ 
%token <character> PLUS
%token <character> MINUS
%token <character> MULTIPLY
%token <character> DIVIDE
%token <number> NUMBER
%token <string> WRITE
%token <character> LPAREN
%token <character> RPAREN
%token <character> LBRACK
%token <character> RBRACK
%token <character> LBRACE
%token <character> RBRACE
%token <character> COMMA

%left PLUS MINUS
%left MULTIPLY DIVIDE

%printer { fprintf(yyoutput, "%s", $$); } ID;
%printer { fprintf(yyoutput, "%d", $$); } NUMBER;

%type <ast> Program DeclList Decl VarDecl Stmt StmtList Expr REC Array FuncDecl PARAM

%start Program

%%

Program: DeclList  { 
    $$ = $1;
	printf("\n--- Abstract Syntax Tree ---\n\n");
	printAST($$,0);
};


DeclList:	Decl DeclList	{
    $1->left = $2;
	$$ = $1;
}
| Decl	{
    $$ = $1; 
};


Decl:	VarDecl
	| FuncDecl
	| StmtList
;

VarDecl:	TYPE ID SEMICOLON { 
    	char id1[50];
    	printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);
	symTabAccess();
	int inSymTab = found($2, currentScope);
	if (inSymTab == 0) 
		addItem($2, "Var", $1, 0, currentScope);
	else
		printf("SEMANTIC ERROR: Var %s is already in the symbol table", $2);
	showSymTable();
    	sprintf(id1, "%s", $2);
    	int numid = getID(id1, currentScope);
    	emitConstantIntAssignment ($2, numid);							
	$$ = AST_Type("Type",$1,$2);
	printf("-----------> %s", $$->LHS);
}
		| TYPE ID Array SEMICOLON {char id1[50];
    	printf("\n RECOGNIZED RULE: Array declaration %s\n", $2);
	symTabAccess();
	int inSymTab = found($2, currentScope);
	if (inSymTab == 0) 
		addItem($2, "Array", $1, 0, currentScope);
	else
		printf("SEMANTIC ERROR: Array %s is already in the symbol table", $2);
	showSymTable();
    	sprintf(id1, "%s", $2);
    	int numid = getID(id1, currentScope);
    	emitConstantIntAssignment ($2, numid);							
	$$ = AST_Type("Type",$1,$2);
	printf("-----------> %s", $$->LHS);
}
;

FuncDecl:	{}
		| TYPE ID LPAREN PARAM RPAREN LBRACE VarDecl RBRACE {
			char id1[50];
    	printf("\n RECOGNIZED RULE: Function declaration %s\n", $2);
	funcSymTabAccess();
	int inSymTab = funcFound($2, currentScope);
	if (inSymTab == 0) 
		funcAddItem($2, "Func", $1, 0, currentScope);
	else
		printf("SEMANTIC ERROR: Function %s is already in the symbol table", $2);
	showFuncSymTable();
    	sprintf(id1, "%s", $2);
    	int numid = getFuncID(id1, currentScope);
    	emitConstantIntAssignment ($2, numid);	
	$$ = AST_Type("Type",$1,$2);
	printf("-----------> %s", $$->LHS);
		}
;

StmtList:	{}
	| Stmt StmtList
;

Stmt:	SEMICOLON {}
	| Expr SEMICOLON {
        $$ = $1;
    }
;

Expr:	LPAREN Expr RPAREN {}

	| ID EQ REC { 
		printf("\n RECOGNIZED RULE: Simplest expression\n"); 
           	char id1[50], id2[50];
            	sprintf(id1, "%s", $1);
            	sprintf(id2, "%d", sum);
            	int numid = getID(id1, currentScope);
            	emitIR(id1, id2, numid);
            	emitMIPSConstantIntAssignment(id1, id2, numid);		
            	sum = 0;		
        }

        | ID EQ ID { 
            	printf("\n RECOGNIZED RULE: Assignment statement\n"); 
            	$$ = AST_assignment("=",$1,$3);
            	if(found($1, currentScope) != 1) {
                	printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $1, currentScope);
                	semanticCheckPassed = 0;
            	}
            	if(found($3, currentScope) != 1){
                	printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $1, currentScope);
                	semanticCheckPassed = 0;
            	}
            	printf("\nChecking types: \n");
            	int typeMatch = compareTypes ($1, $3, currentScope);
            	
		if (typeMatch == 0){
                	printf("SEMANTIC ERROR: Type mismatch for variables %s and %s \n", $1, $3);
                	semanticCheckPassed = 0;
            	}

            	if (semanticCheckPassed == 1) {
                	printf("\n\n>>> AssignStmt Rule is SEMANTICALLY correct and IR code is emitted! <<<\n\n");
                	emitAssignment($1, $3);
                	emitMIPSAssignment($1, $3);
            	}
	}

        | ID EQ ID ARRAY { 
            printf("\n RECOGNIZED RULE: Array Assignment statement\n"); 
            $$ = AST_assignment("=",$1,$3);
            if(found($1, currentScope) != 1) {
                printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $1, currentScope);
                semanticCheckPassed = 0;
            }
            if(found($3, currentScope) != 1){
                printf("SEMANTIC ERROR: Array %s has NOT been declared in scope %s \n", $1, currentScope);
                semanticCheckPassed = 0;
            }
            printf("\nChecking types: \n");
            int typeMatch = compareTypes ($1, $3, currentScope);
            if (typeMatch == 0){
                printf("SEMANTIC ERROR: Type mismatch for variables %s and %s \n", $1, $3);
                semanticCheckPassed = 0;
            }
            if (semanticCheckPassed == 1) {
                printf("\n\n>>> AssignStmt Rule is SEMANTICALLY correct and IR code is emitted! <<<\n\n");
                emitAssignment($1, $3);
                emitMIPSAssignment($1, $3);
            }

        }

        | ID EQ NUMBER { 
            printf("\n RECOGNIZED RULE: ID EQ NUMBER\n"); 
            char str[50];
            char id1[50];
            if(found($1, currentScope) != 1) {
                printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $1, currentScope);
                semanticCheckPassed = 0;
            }
            printf("\nChecking types: \n");
            printf("%s = %s\n", "int", "number");  
            if (semanticCheckPassed == 1) {
                printf("\n\nRule is semantically correct!\n\n");
                sprintf(str, "%d", $3); 
                sprintf(id1, "%s", $1);	
                symTabAccess();
                setValue(id1, $3, currentScope);
                showSymTable();
                $$ = AST_assignment("=",$1, str);
                char id1[50], id2[50];
                sprintf(id1, "%s", $1);
                sprintf(id2, "%d", $3);
                int numid = getID(id1, currentScope);
                emitIR(id1, id2, numid);
                emitMIPSConstantIntAssignment(id1, id2, numid);
            }
        }
        
        | WRITE ID { 
            printf("\n RECOGNIZED RULE: WRITE statement\n");
            $$ = AST_Write("write",$2,"");
            char id1[50];
            sprintf(id1, "%s", $2);
            int numid = getID(id1, currentScope);
            if(found($2, currentScope) != 1) {
                printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $2, currentScope);
                semanticCheckPassed = 0;
            }
            if (semanticCheckPassed == 1) {
                printf("\n\nRule is semantically correct!\n\n");
                emitWriteId($2);
                emitMIPSWriteId($2,numid);
            }
            
        }	
;

REC:	NUMBER MULTIPLY REC {
    		printf("\n RECOGNIZED RULE: NUMBER * REC\n");
		result = result * $1;			
	}

	| NUMBER DIVIDE REC {
    		printf("\n RECOGNIZED RULE: NUMBER / REC\n");
		result = result / $1;			
	}

	| NUMBER PLUS REC {
    		printf("\n RECOGNIZED RULE: NUMBER + REC\n");
		result = result + $1;			
	}

	| NUMBER MINUS REC {
    		printf("\n RECOGNIZED RULE: NUMBER - REC\n");
		result = result - $1;			
	}

	| ID MULTIPLY REC {
        	printf("\n RECOGNIZED RULE: ID * REC\n");
		symTabAccess();
		char id1[50];
		int id2 = getValue($1, currentScope);
		result = result * id2;
	}

	| ID DIVIDE REC	{
        	printf("\n RECOGNIZED RULE: ID / REC\n");
		symTabAccess();
		char id1[50];
		int id2 = getValue($1, currentScope);
		result = result / id2;
	}

	| ID PLUS REC	{
        	printf("\n RECOGNIZED RULE: ID + REC\n");
		symTabAccess();
		char id1[50];
		int id2 = getValue($1, currentScope);
		result = result + id2;
	}
	
	| ID MINUS REC {
        	printf("\n RECOGNIZED RULE: ID - REC\n");
		symTabAccess();
		char id1[50];
		int id2 = getValue($1, currentScope);
		result = result - id2;
	}

	| NUMBER {
        	printf("\n RECOGNIZED RULE: ADD STATEMENT NUM END\n");
		result = result + $1;
	}

	| ID {
        	printf("\n RECOGNIZED RULE: ADD STATEMENT ID END \n");
		symTabAccess();
		char id1[50];
		int id2 = getValue($1, currentScope);
		result = result + id2;
	}
;

Array:  {}
	| LBRACK RBRACK {}
	| LBRACK NUMBER RBRACK {}
	| LBRACK ID RBRACK {}
;


PARAM:	{}
	| TYPE ID {}
	| COMMA TYPE ID PARAM {}
;

%%

int main(int argc, char**argv) {

	printf("\n\n##### COMPILER STARTED #####\n\n");
	if (argc > 1) {
	    if(!(yyin = fopen(argv[1], "r"))) {
		    perror(argv[1]);
		    return(1);
	    } 
	}


	initIRcodeFile();
	initAssemblyFile();
	yyparse();
	emitEndOfAssemblyCode();

}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}

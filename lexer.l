%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define YY_DECL int yylex()
#include "parser.tab.h"

int words = 0;
int chars = 0;
int lines = 0;

%}

letter      [a-zA-Z]
digit       [0-9]
ID          {letter}({letter}|{digit})*
delim       [ \t\n]
NUMBER      {digit}+(\.{digit}+)?(E[+\-]?(digit)+)?
ws          {delim}+

%%

"/*"    		{
				int c;
				while((c = input()) != 0) {
					if(c == '*') {
						if((c = input()) == '/')
							break;
						else
							unput(c);
					}
				}
			}
						
"int"			{words++; chars += strlen(yytext);
				printf("%s : TYPE\n", yytext);
				yylval.string = strdup(yytext); 
				return TYPE;
			}

"boolean"		{words++; chars += strlen(yytext);
				printf("%s : TYPE\n", yytext);
				yylval.string = strdup(yytext); 
				return TYPE;
			}

"void"			{words++; chars += strlen(yytext);
				printf("%s : TYPE\n", yytext);
				yylval.string = strdup(yytext); 
				return TYPE;
			}

"float"			{words++; chars += strlen(yytext);
				printf("%s : TYPE\n", yytext);
				yylval.string = strdup(yytext); 
				return TYPE;
			}

"write"			{words++; chars += strlen(yytext);
				printf("%s : KEYWORD\n", yytext);
				yylval.string = strdup(yytext); 
				return WRITE;
			}

{ID}			{words++; chars += strlen(yytext);
			  	printf("%s : IDENTIFIER\n",yytext);
			  	yylval.string = strdup(yytext); 
			  	return ID;
			}
			
{NUMBER}		{words++; chars += strlen(yytext);
			  	printf("%s : NUMBER\n",yytext);
			 	yylval.number = atoi(strdup(yytext)); 
			  	return NUMBER;
			}
			
";"			{chars++;
		  		printf("%s : SEMICOLON\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return SEMICOLON;
			}
		
"="			{chars++;
		  		printf("%s : EQ\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return EQ;
			}

"*"			{chars++;
		  		printf("%s : MULTIPLY\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return MULTIPLY;
			}

"/"			{chars++;
		  		printf("%s : DIVIDE\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return DIVIDE;
			}

"+"			{chars++;
		  		printf("%s : PLUS\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return PLUS;
			}

"-"			{chars++;
		  		printf("%s : MINUS\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return MINUS;
			}

"("			{chars++;
		  		printf("%s : LPAREN\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return LPAREN;
			}

")"			{chars++;
		  		printf("%s : RPAREN\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return RPAREN;
			}

"{"			{chars++;
		  		printf("%s : LBRACE\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return LBRACE;
			}

"}"			{chars++;
		  		printf("%s : RBRACE\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return RBRACE;
			}

"["			{chars++;
		  		printf("%s : LBRACK\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return LBRACK;
			}

"]"			{chars++;
		  		printf("%s : RBRACK\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return RBRACK;
			}

","			{chars++;
		  		printf("%s : COMMA\n", yytext);
		  		yylval.string = strdup(yytext); 
		  		return COMMA;
			}


[\n]	{lines++; chars = 0;}
[ \t]	{chars++;}
.		{chars++;
         printf("%s : Unrecognized symbol at line %d char %d\n", yytext,lines,chars);
		}
		

%%

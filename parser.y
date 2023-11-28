/* Compiler Theory and Design
   Dr. Duane J. Jarc */
%{
extern int lineNumber;
extern char* yytext;
#include <string>
using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);
void appendError(ErrorCategories errorCategory, string message);

%}

%token IDENTIFIER INT_LITERAL REAL_LITERAL BOOL_LITERAL
%token ADDOP MULOP RELOP OROP ANDOP EXPOP REMOP 
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS CASE ELSE ARROW
%token ENDCASE ENDIF IF OTHERS REAL THEN WHEN NOT
%token ERROR_TOKEN 

%%

function:
    function_header optional_variable body  
    | error {yyclearin;}
    ;

function_header:  
    FUNCTION IDENTIFIER RETURNS type ';'
    | FUNCTION IDENTIFIER error { yyerror("':' or 'RETURNS'"); }
    ;
    
optional_variable:
    optional_variable variable | 
    ;
  
variable:  
    IDENTIFIER ':' type IS statement_ ;
  
optional_parameter:
    optional_parameter RETURNS type ',' |
    parameter ;
  
parameter:  
    IDENTIFIER ':' type |
    ;
  
type: INTEGER | REAL | BOOLEAN ;
  
body:  
    BEGIN_ statement_ END ';' ;

statement_:
    statement ';'
   | error ';' { yyerror("Unexpected ';'"); }
   | error INT_LITERAL ';' { yyerror("Unexpected INT_LITERAL"); }
   | error IDENTIFIER ';' { yyerror("Unexpected IDENTIFIER"); }
   | error REAL_LITERAL ';' { yyerror("Unexpected REAL_LITERAL"); }
   | error ADDOP ';' { yyerror("Unexpected ADDOP"); }
   ;

statement:
	expression |
	REDUCE operator reductions ENDREDUCE |
	IF expression THEN statement_ ELSE statement_ ENDIF |
	CASE expression IS optional_cases OTHERS ARROW statement_ ENDCASE ;

reductions:
	reductions statement_ |
	;

optional_cases:
	optional_cases case |
	;

case:
	WHEN INT_LITERAL ARROW statement_ ;

operator:
	ADDOP |
	MULOP REMOP |
	EXPOP ;

expression:
	expression ANDOP relation |
	expression2;

expression2:
	expression OROP relation |
	relation;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP factor |
	factor ;

factor:
	factor MULOP primary |
	factor REMOP |
	exponent ;

exponent:
	factor EXPOP notion |
	notion;

notion:
	notion NOT primary |
	primary;

primary:
	'(' expression ')' |
	INT_LITERAL | REAL_LITERAL | BOOL_LITERAL |
	IDENTIFIER ;

%%

void yyerror(const char* message) 
{
	// Construction of error message, was a pain to figure out
    string errorMsg = "Syntax Error, Unexpected " + string(yytext);
    if (message != NULL) 
    {
        errorMsg += ", expecting " + string(message);
    }
	// Append error to listing, also annoying
    appendError(SYNTAX, errorMsg);
}

int main() {

  yyparse();
  lastLine();
  return 0;
}

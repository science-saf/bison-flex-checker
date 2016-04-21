%{

#include "grammar.gen.h"
#define yylex checker_lex

%}

NUMBER [0-9]+
BOOL true|false
STRING \".*\"
ID [a-zA-Z][a-zA-Z0-9_]*

/* Опция, необходимая для языков с препроцессорами и #include, в нашем случае не нужна */
%option noyywrap

%option nounistd

%option always-interactive

%%

"("     return '(';
")"     return ')';
"="     return '=';
"+"     return '+';
"-"     return '-';
"*"     return '*';
"/"     return '/';
"<"     return '<';
"&&"    return AND;
"["     return '[';
"]"     return ']';
"{"     return '{';
";"     return ';';
"}"     return '}';
{BOOL}   return BOOL;
{NUMBER} return NUMBER;
{STRING} return STRING;
return  return RETURN;
while   return WHILE;
if      return IF;
else    return ELSE;
"System.out.println"   return PRINT;
public  return PUBLIC;
static  return STATIC;
void    return VOID;
main    return MAIN;
class   return CLASS;
extends return EXTENDS;
new     return NEW;
int     return KW_INT;
boolean return KW_BOOLEAN;
String  return KW_STRING;
{ID}    return ID;
[ \t\r\n]+  /* skip */

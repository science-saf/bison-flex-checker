/** Файл содержит основанный на Bison LALR-парсер,
    способный проверить принадлежность входных данных грамматике языка.

    Основано на https://github.com/bingmann/flex-bison-cpp-example/blob/master/src/parser.yy
    */

%start program

%{
#include <stdio.h>
#include "globals.h"

/*
    Функция для вывода сообщения об ошибке должна быть определена вручную.
    При этом мы определяем checker_error вместо yyerror,
    так как ранее применили директиву %name-prefix
*/
void checker_error (char const *s) {
    ++g_errorsCount;
    fprintf (stderr, "Error: %s\n", s);
}
%}

/* Директива вызовет генерацию файла с объявлениями токенов.
   Генератор парсеров должен знать целочисленные коды токенов,
   чтобы сгенерировать таблицу разбора. */
%defines

/* Префикс будет добавлен к идентификаторам генерируемых функций */
%name-prefix "checker_"

/* Подробные сообщения об ошибках разбора по грамматике. */
%error-verbose

%token END 0    "end of file"
%token NUMBER   "Number constant"
%token STRING   "String constant"
%token BOOL     "Bool constant"
%token ID       "Identifier"
%token WHILE    "while"
%token IF       "if"
%token ELSE     "else"
%token RETURN   "return"
%token AND      "operator &&"
%token PRINT    "System.out.println"
%token NEW      "new"
%token PUBLIC   "public"
%token VOID     "void"
%token STATIC   "static"
%token MAIN     "main"
%token EXTENDS  "extends"
%token KW_INT      "int"
%token KW_BOOLEAN  "boolean"
%token KW_STRING "String"
%token CLASS    "class"
%token THIS     "this"
%token LENGTH   "length"

/* %left, %right, %nonassoc и %precedence управляют разрешением
   приоритета операторов и правил ассоциативности

   Документация Bison: http://www.gnu.org/software/bison/manual/bison.html#Precedence-Decl
*/
%left '<' AND
%left '+' '-'
%left '*' '/'
%right '=' '!'
%nonassoc '['
%left '.'

%% /* Грамматические правила */

epsilon : /*empty*/

constant : BOOL | NUMBER | STRING

variable_decl : type ID ';' | variable_decl type ID ';'

variable : ID

function_call : ID '(' expression_list ')'

method_call : expression '.' function_call

length_access : expression '.' LENGTH

new_expression : NEW function_call | NEW KW_INT '[' expression ']'

expression : constant | variable | '(' expression ')'
        | '!' expression
        | expression '<' expression | expression AND expression
        | expression '+' expression | expression '-' expression
        | expression '*' expression | expression '/' expression
		| expression '[' expression ']'
		| THIS
        | function_call
		| length_access
		| method_call
		| new_expression

expression_list : epsilon | expression | expression_list ',' expression

while_head : WHILE '(' expression ')'

while_body : statement_line | block

while_statement : while_head while_body | while_head ';'

if_statement : IF '(' expression ')' statement ELSE statement

statement : PRINT '(' expression ')'
          | variable '=' expression
          | variable '[' expression ']' '=' expression
          | block

statement_line : error ';'
		| statement ';'
		| while_statement
		| if_statement

statement_list : statement_line | statement_list statement_line

block : '{' statement_list '}' | '{''}'

type : KW_INT '[' ']'
        | KW_BOOLEAN
        | KW_INT
        | ID

parameter_list : type variable | parameter_list ',' type variable

method_list : method_declaration | method_list method_declaration

method_head : PUBLIC type ID '(' parameter_list ')'
		| PUBLIC type ID '(' epsilon ')'

method_body_inner_non_empty : variable_decl statement_list
		| variable_decl
		| statement_list

method_body_inner : epsilon | method_body_inner_non_empty

method_body : '{' method_body_inner RETURN expression ';' '}'

method_declaration : method_head method_body

class_list_non_empty : class_declaration | class_list_non_empty class_declaration

class_list : epsilon | class_list_non_empty

class_declaration : CLASS ID '{' variable_decl method_list '}'
            | CLASS ID EXTENDS ID '{' variable_decl method_list '}'

main_class : CLASS ID '{' PUBLIC STATIC VOID MAIN '(' KW_STRING '[' ']' ID ')' '{' statement_list '}' '}'

program : main_class class_list

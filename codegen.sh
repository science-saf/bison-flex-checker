#!/usr/bin/env bash

flex -d -L -olexer.gen.c lexer.l
bison -v --no-lines --defines=grammar.gen.h --output=grammar.gen.c --graph=grammar.dot grammar.y

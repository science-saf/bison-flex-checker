cd win_flex_bison-latest
win_flex -L -o "../lexer.gen.c" "../lexer.l"
win_bison --no-lines --defines="../grammar.gen.h" --output="../grammar.gen.c" --graph="../grammar.dot" "../grammar.y"

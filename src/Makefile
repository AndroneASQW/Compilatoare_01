# Usage
#
# make       - build the application
# make test  - test the application
# make clean - remove generated files

NAME=compiler
C_FILES=helper.c
HDR_FILES=helper.h
GENERATED_C_FILES=$(NAME).tab.c $(NAME).yy.c
GENERATED_FILES=$(NAME).tab.c $(NAME).yy.c $(NAME).tab.h

$(NAME): $(GENERATED_FILES) $(C_FILES) $(HDR_FILES)
	gcc -o $@ $(GENERATED_C_FILES) $(C_FILES)

%.yy.c: %.lex
	flex -o $@ $<

%.tab.c %.tab.h: %.y
	bison -d -o $*.tab.c $<
	
clean:
	rm -f $(NAME) $(GENERATED_FILES) $(C_FILES:.c=.o)

# Usage
#
# make       - build the application
# make test  - test the application
# make clean - remove generated files

all:
	make -C src
	make -C test

clean:
	make -C src clean
	make -C test clean

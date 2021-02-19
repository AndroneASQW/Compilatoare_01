test:
	arm-linux-gnueabi-gcc -static -o testgcc.arm testfunc.c testmain.c
	qemu-arm testgcc.arm > testgcc.result
	@echo
	@echo === TEST GCC ===
	@echo
	@cat testgcc.result
	@echo
	../src/compiler < testfunc.c > testfunc.s
	@echo
	@echo === GENERATED CODE ===
	@echo
	@cat testfunc.s
	@echo
	arm-linux-gnueabi-as -o testfunc.o testfunc.s
	arm-linux-gnueabi-gcc -c testmain.c
	arm-linux-gnueabi-gcc -static -o testcompiler.arm testfunc.o testmain.o
	qemu-arm testcompiler.arm > testcompiler.result
	@echo
	@echo === TEST COMPILER ===
	@echo
	@cat testcompiler.result
	@echo
	
install-ubuntu:
	sudo apt install gcc-arm-linux-gnueabi
	sudo apt install qemu-user

clean:
	rm -f *.result *.o *.arm *.s


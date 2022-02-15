default:
	nasm -f elf64 su.asm
	nasm -f elf64 add.asm
	nasm -f elf64 add_del_user.asm
	ld -nostdlib -o su su.o
	ld -nostdlib -o add add.o
	ld -nostdlib -o add_del_user add_del_user.o
	python3 create_commands.py
	./run.sh < commands.sh

build:
	nasm -f elf64 su.asm
	nasm -f elf64 add.asm
	nasm -f elf64 add_del_user.asm
	ld -nostdlib -o su su.o
	ld -nostdlib -o add add.o
	ld -nostdlib -o add_del_user add_del_user.o
	python3 create_commands.py
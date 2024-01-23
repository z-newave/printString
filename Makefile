make:
# This will also output assembly listings as well as a memory map
	cl65 -t cx16 -o printString.PRG -l printString.list --mapfile printString.map printString.asm 

clean:
	rm -f *.PRG *.list *.o

make:
  # This will also output assembly listings as well as a memory map
  cl65 -t cx16 -o lovlttr.PRG -l lovlttr.list --mapfile lovlttr.map lovlttr.asm 

clean:
	rm -f *.PRG *.list *.o

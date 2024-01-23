# printScreen - print routine for the Commander X16

A routine which prints a null-terminated string from a memory address up to 65,535 bytes to the screen.

Written for the CC65 compiler suite for the Commander X16 (but can easily be ported to other assemblers and/or 6502-based computer systems).

## BUILDING
To build using the CC65 suite to output a .PRG file compatible with the [Commander X16 emulator](https://github.com/x16community/x16-emulator), simply run:

`cl65 -t cx16 -o printString.PRG`

## TO-DO
* Make the delay subroutine togglable by setting the number of times (0 to 255) to run delay after each byte printed

## CREDITS
* The delay and delayloop subroutines were written by [Jamie Bainbridge](https://superjamie.github.io/2020/01/14/delay-loop-in-6502-assembly)
* The 8-Bit Guy for developing such an entertaining 6502 development environment

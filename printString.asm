;    printString - Commander X16 routine to print null-terminated string
;    ***********************************************************************
;
;    Copyright (C) 2024 Zappi
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <https://www.gnu.org/licenses/>.
;
;    ***********************************************************************
;
;    This routine prints a null-terminated string (limited by the 16-bit int
;    limit) to the screen using the KERNAL's CHROUT routine. 
;
;    It uses a 16-bit pointer stored in the zero-page (HIGHBYTE and LOWBYTE),
;    that points to the memory address where printing should start. The 
;    Accumulator, acting as a counter for the current byte, increments the 
;    low-byte of the pointer (LOWBYTE) when it overflows (>= #$FF) to allow 
;    for printing up to 65,535 bytes as PETSCII characters.
;
;    To set the address of the text to be printed in an assembler, define the
;    str_start variable to an address (for example, adding it as a label 
;    before raw PETSCII bytes)
;
;    EFFECTS: all registers saved and restored. No changes to A, X or Y.
;    MEMORY USED: $10 through $18 of the zero-page (9 bytes, though only 6
;    used currently. 7 if the delay function is used)

.org $080D                      ; change if embedding in something else
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"

; Define some KERNAL routines
.define CHROUT $FFD2

; Define some variables
.define HIGHBYTE    $10         ; remember that the 6502 is little-endian; 
.define LOWBYTE     $11         ; addresses will be stored high-byte first
.define A_REG       $12
.define X_REG       $13
.define Y_REG       $14
.define A_REG_TMP   $15
.define DELAY_HBYTE $18

.segment "CODE"

.code
printString:
    sta A_REG                   ; save all regs to restore before returning
    stx X_REG
    sty Y_REG

; Uncomment below code and assign the str_start label to a block of raw bytes
; if using an assembler to print data directly rather than setting the address
; in another program and calling printString.
;
;   ldx #<str_start             ; store the high byte of $str_start 
;   stx HIGHBYTE
;   ldx #>str_start             ; store the low byte of $str_start
;   stx LOWBYTE

loop:
    lda (HIGHBYTE), Y           ; load from address $HIGHBYTE, plus counter
    beq end                     ; if zero exit
    jsr CHROUT                  ; run KERNAL subroutine CHROUT
    cpy #$FF                    ; see if counter is at its limit
    beq increment               ; if so increment LOWBYTE and reset counter
    clc                         ; clear results of above comparison
    iny                         ; increment counter
    jmp loop                    ; repeat

 increment:                  
    inc LOWBYTE                 ; increment LOWBYTE 
    ldy #$00                    ; clear out counter
    jmp loop                    ; jump back
   
; delay - make the X16 pause for a moment by counting 0 to 65535
;
; The delay and delayloop subroutines were written by Jamie Bainbridge: 
; https://superjamie.github.io/2020/01/14/delay-loop-in-6502-assembly 
;
; TODO: Make the delay between letters togglable by setting number of times
;       to run somewhere in zero-page, including none at all (no delay)
; These have been commented out until the above is implemented to save space

; delay:
;   sta A_REG_TMP               ; save A-reg state
;   lda #$00                    ; clear A-reg
;   sta DELAY_HBYTE             ; save 0 to DELAY_HBYTE too
;
; delayloop:
;   adc #$01                    ; add 1 to A-reg
;   bne delayloop               ; loop until A-reg overflows
;   clc                         ; clear carry flag so it doesn't affect ADC
;   inc DELAY_HBYTE             ; increment the high byte
;   bne delayloop               ; loop until high byte overflows
;   clc                         ; clear carry flag
;   lda A_REG_TMP               ; restore A-reg
;   rts                         ; return

end:            
    lda A_REG                   ; restore all registers to the way they were
    ldx X_REG
    ldy Y_REG
    rts                         ; return!

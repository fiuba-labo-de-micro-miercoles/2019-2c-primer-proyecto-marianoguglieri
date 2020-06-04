.include "m328pdef.inc"

.cseg 
.org 0x0000
			jmp		main

.org INT_VECTORS_SIZE
main:
			
; Led en PB5 
; Configuro puerto B
			ldi		r20,0xff	;(PORTB como salida)
			ldi     r23, 0xff   ;cargo r23 con el valor 0xff
			out		DDRB,r20

; rutina de encendido y apagado
		
prendo:		out PORTB,r23  	         ; encendido del led

demora1:
			ldi		r20, 32 
loop3:		ldi		r21, 255
loop2:		ldi		r22, 255
			
loop1:		dec		r22
			brne	loop1
			dec		r21
			brne	loop2
			dec		r20
			brne	loop3			
						
			out		PORTB,r20		; apagado del led

demora2:
			ldi		r20, 32 
loop6:		ldi		r21, 255
loop5:		ldi		r22, 255
			
loop4:		dec		r22
			brne	loop4
			dec		r21
			brne	loop5
			dec		r20
			brne	loop6

			RJMP	prendo		; reinicio el ciclo

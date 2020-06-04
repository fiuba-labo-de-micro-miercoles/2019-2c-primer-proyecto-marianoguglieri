.include "m328pdef.inc"

.cseg

;declaro macros
.EQU	entrada =	PINB						
.EQU	salida  =	PORTB
.EQU	pull_up =	PORTB
		
		jmp		main			  

.org INT_VECTORS_SIZE				   

main:
;declaro los puertos de entrada y salida
		cbi		DDRB,		3
		sbi		pull_up,	3	;activo la resistencia de pull up
		sbi		DDRB,		0


no_pulsado:		sbic entrada,	3
				jmp no_pulsado
				sbi salida,		0

pulsado:		sbis entrada,   3
				jmp pulsado
				cbi salida,		0

				jmp no_pulsado

;ACA:	SBIC	PINB, 3
;		CBI		PORTB, 0
;		SBIC	PINB, 3
;		RJMP	ACA
;		SBI		PORTB, 0
;		RJMP	ACA 

 
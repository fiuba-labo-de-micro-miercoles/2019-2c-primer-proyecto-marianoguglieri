.include "m328pdef.inc"

.cseg 
	;direcciones de codigo
.org 0x0000
	rjmp	configuracion
.org OVF1addr
	rjmp	 TO_1V_ISR
.org INT_VECTORS_SIZE

configuracion:
	;inicializo el stack
	ldi		R16, HIGH(RAMEND)							
	out		SPH, R16
	ldi		R16, LOW(RAMEND)
	out		SPL, R16

	;declaro el PORTB como salida
	sbi		DDRB, 0

	;declaro el PORTD como entrada 
	cbi		DDRD, 0
	cbi		DDRD, 1

	;enciendo la interrupcion por overflow del timer1
	ldi		R16, (1<<TOIE1)
	sts		TIMSK1, R16

	sei

main:
	in		R16, PIND				;verifico estado puerto D

	rcall   polling					;entro a la rutina de polling
	jmp		main

polling:
	cpi		R16, 0					;lo que se hace aca, es ir comparando los valores del puerto D con  
	breq	fijo					;los 4 estados posibles. Cuando el puerto sea igual a uno, se modifica el 
									;prescaler acorde a las intrucciones del TP.
	cpi		R16, 1					
	breq	clk_64
		
	cpi		R16, 2
	breq	clk_256
		
	cpi		R16, 3
	breq	clk_1024

	fijo: 
		ldi		R16, 0x00							
		sts		TCCR1B, R16
		sbi		PORTB, 0				;por default, el led se encuentra encendido 
	ret

	clk_64: 
		ldi		R16, 0X03						
		sts		TCCR1B, R16				;aca se esta modificando el registro de control, utilizando los prescalers 
	ret

	clk_256: 
		ldi		R16, 0X04							
		sts		TCCR1B, R16	
	ret

	clk_1024: 
		ldi		R16, 0X05							
		sts		TCCR1B, R16	
	ret

TO_1V_ISR:							;rutina de encendido y apagado del led
		sbis	PORTB, 0			;se ejecutara cuando el conteo del timer produzca un overflow
		rjmp	enciendo
		cbi		PORTB, 0
reti

		enciendo:
		sbi		PORTB, 0
reti
	

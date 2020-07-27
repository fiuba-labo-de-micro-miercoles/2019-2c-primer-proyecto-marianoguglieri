.include "m328pdef.inc"

.cseg 
	;direcciones de codigo
.org 0x0000
	jmp		configuracion
.org ADCCaddr
	rjmp	 adc_isr
.org INT_VECTORS_SIZE

configuracion:
	;inicializo el stack
	ldi		R16, HIGH(RAMEND)							
	out		SPH, R16
	ldi		R16, LOW(RAMEND)
	out		SPL, R16

	;declaro el PORTB como salida
	ldi		R16,0xff
	out		DDRB,R16

	;declaro el PORTC como entrada 
	ldi		R16, 0x00						
	out		DDRC, R16

	;configuro la entrada analógica:
	;ADCEnable, Interrupt enable, Prescales 128
    ldi		R16, 0xaf
    sts		ADCSRA,R16
	;Vref=Vcc, LeftAdjust, ADC0
    ldi		R16, 0x60
    sts		ADMUX,R16

	sei

	main:	
		
			lds		R16, ADCSRA ; start conversion	
			ori		R16, 0x40
			sts		ADCSRA, R16

		

	fin:	jmp		fin


	adc_isr:						;Lo que hace el adc, carga un valor en el registro y chau 
		lds R16, ADCH
		lsr R16
		lsr R16
		out PORTB, R16
	reti
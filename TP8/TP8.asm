.include "m328pdef.inc"

.cseg 
.org 0x0000
	jmp		configuracion
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

	;declaro los pines del PORTD
	ldi		R16, 0xfe						
	out		DDRD, R16

	;configuro BAUD RATE
	ldi		R16, 0x00
	sts		UBRR0H, R16 
	ldi		R16, 103
	sts		UBRR0L, R16 

	;Habilito puerto receptor y emisor
	ldi		R16, (1<<RXEN0) | (1<<TXEN0) 
	sts		UCSR0B, R16

	;Frame format: 8bit data, 1 stop bit, no parity 
	ldi		R16, (1<<UCSZ01) | (1<<UCSZ00)
	sts		UCSR0C, R16

	sei

main:													
						ldi		ZH, HIGH(secuencia1 <<1)		;En esta sección mando la cadena que se leerá en la terminal.		
						ldi		ZL, LOW (secuencia1 <<1)		;El código implementado es prácticamente al realizado en el TP3
						ldi		R17, 68									   

	siguiente:			lpm		R16, Z+			
	USART_Transmit:		lds		R18, UCSR0A						;Me fijo cuando el bit UDRE0 del registro UCSR0A se pone en 1
						sbrs	R18, UDRE0						;Si se pone en 1, está listo para mandar el siguiente dato
						rjmp	USART_Transmit				
						sts		UDR0, R16			
						dec		R17
						brne	siguiente
	;-----------------**************************************-------------------------------
						clr		R17
	USART_Receive:
						lds		R18, UCSR0A						;Loop que espera a recibir data
						sbrs	R18, RXC0						;cuando se recibe data, el bit RXC0 se activa saliendo del loop
						rjmp	USART_Receive
						lds		R16, UDR0

						andi	R16, 0x0f						;Mascara para descartar los bits que no me sirven
							
						cpi		R16, 1							;Todas las entradas que no sean 1,2,3 o 4 no deberian 
						brlo	USART_Receive					;hacer nada
						cpi		R16, 5
						brcc	USART_Receive
				
						sbrc	R16,2							;Si la entrada es un 4
						lsl		R16	

						cpi		R16,3							;Si la entrada es un 3
						brne	no_es_un_3
						inc		R16

		no_es_un_3:		eor		R17, R16						;xor entre el registro r17 y r16 para cambiar de estado bajo a alto
						out		PORTB, R17						;o de alto o bajo. Saco por el puerto B el estado

	rjmp	USART_Receive
					
secuencia1:
.DB '*','*','*',' ','H','o','l','a',' ','L','a','b','o',' ','d','e',' ','M','i','c','r','o',' ','*','*','*','\n','E','s','c','r','i','b','a',' ','1',',','2',',','3',' ','o',' ','4',' ','p','a','r','a',' ','c','o','n','t','r','o','l','a','r',' ','l','o','s',' ','L','E','D','s'
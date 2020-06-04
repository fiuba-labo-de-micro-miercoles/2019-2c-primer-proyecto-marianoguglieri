.include "m328pdef.inc"                ;carpeta que incluye nombres de puertos y constantes para el atmega328p                                     

.cseg								   ;indica que todo lo que viene a continuación tiene que estar en la memoria del programa. Es código ejecutable
.org 0x0000							   ;que empiece en la dirección 0
			jmp		main			   ;salto a la etiqueta de cógido donde se encuentra main 

.org INT_VECTORS_SIZE				   ;salta a donde hay espacio libre en donde no hay espacio reservado  
main:
			
; Configuro puerto B
			ldi		r20,0xff		   ; cargo r20 con el valor 0xff		
			out		DDRB,r20		   ;(PORTB como salida)

; rutina de encendido y apagado
		
prendo:		sbi		PORTB,1 	       ; encendido del led
			;ldi		r21, 0x20
			;out		PORTB, r21
	
demora1:							   
			ldi		r20, 32			   ; cargo r20 con el valor 32
loop3:		ldi		r21, 255		   ; cargo r21 con el valor 255
loop2:		ldi		r22, 255		   ; cargo r22 con el valor 255
			
loop1:		dec		r22				   ; decremento r22 
			brne	loop1			   ; veo el flag de Z para ver si llego a 0
			dec		r21				   ; decremento r21 
			brne	loop2			   ; veo el flag de Z para ver si llego a 0
			dec		r20				   ; decremento r20
			brne	loop3			   ; veo el flag de Z para ver si llego a 0
			
			cbi		PORTB,1		       ; apagado del led

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

			RJMP	prendo		       ; reinicio el ciclo

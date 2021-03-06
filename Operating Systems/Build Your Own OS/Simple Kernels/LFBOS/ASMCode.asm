[BITS 32]
; NASM IntOff.asm -f elf
; produces a elf 32 bit binary

global _PrintASMMessage
global _WaitForESC
global _LeaveKernel

SECTION .text

_PrintASMMessage:	
			mov ebx,0xB8000
			mov esi,STRING							; pointer to STRING
			mov ecx,17								; number of characters
			mov edx,0								; index
REPEAT:
			mov ax,[esi+edx]
			and ax,0x00FF
			or ax,0x0700							; attribute byte
			mov [ebx+2*edx],ax
			inc edx
			loop REPEAT								; repeat ECX times
			ret
			
_WaitForESC:
			in al,0x60
			cmp al,1
			jne _WaitForESC
			ret

_LeaveKernel:
			mov esp,ebp
			pop ebp
			retf
			
SECTION .data

STRING:	
			db "Assembler in C++!"

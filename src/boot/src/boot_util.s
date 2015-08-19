; =====================================================================
; CalicOS
; Copyright (C) 2015 David Jolly
; ----------------------
;
; CalicOS is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
; 
; CalicOS is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
; =====================================================================

; ========================
; Boot Routine Section
; ========================

_util_clear:
	pusha
	push bx
	push cx
	push dx
	mov ah, 0x07
	mov al, 0x00				; clear
	mov bh, 0x07				; color
	mov cx, 0x0000				; start row/column
	mov dx, 0x184f				; end row/column
	int 0x10				; scroll window
	mov ah, 0x02
	mov bh, 0x00				; page number
	mov dx, 0x0000				; cursor row/column
	int 0x10				; reset cursor position
	pop dx
	pop cx
	pop bx
	popa
	ret
	
_util_error:
	mov si, _msg_fail
	call _util_print			; print error message
	call _util_reboot			; reboot
	
_util_freeze:
	cli
	hlt

_util_print:
	pusha
	push si
._util_print_next:
	mov al, [si]				; retrieve character
	cmp al, 0x00
	je ._util_print_done			; exit on terminator
	mov ah, 0x0e
	int 0x10				; print character
	inc si					; advance to next character
	jmp ._util_print_next
._util_print_done:
	pop si
	popa
	ret

_util_read:
	pusha
	push si
	mov si, 0x03				; max trial count
._util_read_trial:
	cmp si, 0x00
	je _util_error				; error on exceed max trail
	dec si					; decrement trial count
	mov ah, 0x02
	int 0x13				; read from disk
	jc ._util_read_trial			; loop on read error
	pop si
	popa
	ret
	
_util_reboot:
	mov si, _msg_newline
	call _util_print			; print newline
	mov si, _msg_reboot
	call _util_print			; print reboot message
	call _util_wait
	int 0x19				; reboot
	
_util_wait:
	pusha
	xor ah, ah
	int 0x16				; wait for keystroke
	popa
	ret

; ========================
; Boot String Section
; ========================

_msg_done:
	db 'Done.', 0x00

_msg_fail:
	db 'Failed!', 0x00

_msg_newline:
	db 0x0d, 0x0a, 0x00

_msg_reboot:
	db 'Press any key to reboot...', 0x00

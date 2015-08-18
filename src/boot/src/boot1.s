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

	bits 16
	org 0x0000

	jmp short _boot				; jump to boot code

; ========================
; Boot Code Section
; ========================

_boot:
	cli
	mov ax, 0x7e00				; clear registers
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov bp, 0x7e00
	mov sp, 0x7e00				; setup stack
	sti

	mov si, _msg_load
	call _util_print

	; TODO
	mov si, _msg_done
	call _util_print
	call _util_reboot
	; ---

	call _util_freeze

; ========================
; Boot Utilities Section
; ========================

%include './src/boot_util.s'

; ========================
; Boot String Section
; ========================

_msg_load:
	db 0x0d, 0x0a, '** Loading kernel... ', 0x00

; ========================
; Boot Fill Section
; ========================

	times 0x0400 - ($ - $$) db 0x00
